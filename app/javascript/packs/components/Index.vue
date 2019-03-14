<template>
  <div class="task">
    <!-- 新規作成部分 -->
    <div class="row">
      <div class="col s10 m11">
        <input
          v-model="newTask"
          @keyup.enter="createTask"
          class="form-control"
          placeholder="Add your task!!"
        >
      </div>
      <div class="col s2 m1">
        <div @click="createTask" class="btn-floating waves-effect waves-light">
          <i class="material-icons">add</i>
        </div>
      </div>
    </div>
    <!-- リスト表示部分 -->
    <div>
      <ul class="collection">
        <li
          v-for="task in tasks"
          v-if="!task.is_done"
          v-bind:id="'row_task_' + task.id"
          class="collection-item"
        >
          <label>
            <input
              type="checkbox"
              @change="doneTask(task.id)"
              class="filled-in"
              v-bind:id="'task_' + task.id"
            >
            <span v-bind:for="'task_' + task.id">{{ task.name }}</span>
          </label>
          <button @click="deleteTask(task.id)" class="btn-small red button-location">Delete</button>
        </li>
      </ul>
    </div>
    <!-- 完了済みタスク表示ボタン -->
    <div class="btn" @click="displayFinishedTasks">finished tasks</div>
    <!-- 完了済みタスク一覧 -->
    <div id="finished-tasks" class="display_none">
      <ul class="collection">
        <li
          v-for="task in tasks"
          v-if="task.is_done"
          v-bind:id="'row_task_' + task.id"
          class="collection-item"
        >
          <label>
            <input
              type="checkbox"
              class="filled-in"
              v-bind:id="'task_' + task.id"
              checked="checked"
            >
            <span v-bind:for="'task_' + task.id" class="line-through">{{ task.name }}</span>
          </label>
          <button @click="deleteTask(task.id)" class="btn-small red button-location">Delete</button>
        </li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from "axios";

axios.defaults.headers.common = {
  "X-Requested-With": "XMLHttpRequest",
  "X-CSRF-TOKEN": document
    .querySelector('meta[name="csrf-token"]')
    .getAttribute("content")
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
    createTask: function() {
      if (!this.newTask) return;

      axios.post("/api/tasks", { task: { name: this.newTask } }).then(
        res => {
          this.tasks.unshift(res.data.task);
          this.newTask = "";
        },
        error => {
          console.log(error);
        }
      );
    },
    fetchTasks: function() {
      axios.get("/api/tasks").then(
        res => {
          // for(var i = 0; i < res.data.tasks.length; i++) {
          //   this.tasks.push(res.data.tasks[i]);
          // }
          const tasks = res.data.tasks.map(task => {
            return task;
          });
          this.tasks = tasks;
        },
        error => {
          console.log(error);
        }
      );
    },
    doneTask: function(task_id) {
      axios.put("/api/tasks/" + task_id, { task: { is_done: 1 } }).then(
        res => {
          this.fetchTasks();
          // this.moveFinishedTask(task_id)
        },
        error => {
          console.log(error);
        }
      );
    },
    deleteTask: function(task_id) {
      axios.delete("/api/tasks/" + task_id).then(
        res => {
          const tasks = this.tasks.filter(task => {
            return task.id !== task_id;
          });
          this.tasks = tasks;
        },
        error => {
          console.log(error);
        }
      );
    },
    displayFinishedTasks: function() {
      document
        .querySelector("#finished-tasks")
        .classList.toggle("display_none");
    }
  }
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
  border: none;
}
.collection-item {
  border: 1px solid #e0e0e0 !important;
  position: relative;
}
label > span {
  display: inherit !important;
}
.button-location {
  position: absolute;
  top: 5px;
  right: 20px;
}
</style>
