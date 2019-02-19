<template>
  <div class="task">
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input v-model="newTask" class="form-control" placeholder="Add your task!!" />
      </div>
      <div class="col s2 m1">
        <div v-on:click="createTask" class="btn-floating waves-effect waves-light">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li v-for="task in tasks" v-if="!task.is_done" v-bind:id="'row_task_' + task.id" class="collection-item">
          <label>
            <input type="checkbox" v-on:change="doneTask(task.id)" class="filled-in" v-bind:id="'task_' + task.id">
            <span v-bind:for="'task_' + task.id">{{ task.name }}</span>
          </label>
        </li>

      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" v-on:click="displayFinishedTasks">finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <li v-for="task in tasks" v-if="task.is_done" v-bind:id="'row_task_' + task.id" class="collection-item">
          <label>
            <input type="checkbox" class="filled-in" v-bind:id="'task_' + task.id" checked="checked">
            <span v-bind:for="'task_' + task.id" class="line-through">{{ task.name }}</span>
          </label>
        </li>
      </ul>
    </div>
    <div><pre>{{ $data }}</pre></div>
  </div>
</template>

<script>
import axios from "axios";

axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

export default {
  data: function() {
    return {
      tasks: [],
      newTask: ""
    };
  },
  mounted: function() {
    this.fetchTasks();
  },
  methods: {
    createTask: function(){
      if(!this.newTask) return;

      axios.post('/api/tasks', { task: { name: this.newTask } }).then((res) => {
        this.tasks.unshift(res.data.task)
        this.newTask = '';
      }, (error) => {
        console.log(error);
      })
    },
    fetchTasks: function () {
      axios.get('/api/tasks').then((response) => {
        for(var i = 0; i < response.data.tasks.length; i++) {
          this.tasks.push(response.data.tasks[i]);
        }
      }, (error) => {
        console.log(error);
      });
    },
    doneTask: function(task_id){
      axios.put('/api/tasks/' + task_id, { task: { is_done: 1 } }).then((res) => {
        this.moveFinishedTask(task_id)
      }, (error) => {
        console.log(error)
      })
    },
    moveFinishedTask: function(task_id){
      const el = document.querySelector('#row_task_' + task_id)
      var el_clone = el.cloneNode(true);
      // 未完了の方を先に非表示にする
      el.classList.add('display_none');
      // もろもろスタイルなどをたして完了済みに追加
      el_clone.getElementsByTagName('input')[0].checked = 'checked';
      el_clone.getElementsByTagName('label')[0].classList.add('line-through');
      el_clone.getElementsByTagName('label')[0].classList.remove('word-color-black');
      var li = document.querySelector('#finished-tasks > ul > li:first-child');
      document.querySelector('#finished-tasks > ul').insertBefore(el_clone, li);
    },
    displayFinishedTasks: function(){
      document.querySelector('#finished-tasks').classList.toggle('display_none');
    }
  }
          //res.data.tasks.map(task) => { this.tasks.push(task)};

};


</script>

<style lang="scss" scoped>
[v-cloak] {
  display: none;
}
.display_none {
  display: none;
}
.line-through {
  text-decoration: line-through;
}
.task {
  margin-top: 40px;
}
.collection {
  margin: 15px 0 30px 0;
}
label > span {
  display: inherit !important;
}
</style>
