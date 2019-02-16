import Vue from 'vue/dist/vue.esm.js'
import Header from './components/Header.vue'
import Router from './router/Router.js'

var app = new Vue({
  el: '#app',
  router: Router,
  components: {
    navbar: Header
  }
});