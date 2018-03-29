<template>
  <div v-bind:class="active?'popUpWarp active':'popUpWarp'">
    <div class="popUpframe">
      <span v-on:click="close"><i class="fa fa-times"></i></span>
      <p>{{popUpMsg}}</p>
    </div>
  </div>
</template>

<script>
import {eventBus} from './../widgets/eventBus';
export default {
  name: 'popUp',
  data(){
    return{
      popUpMsg:'',
      active:false,
    }
  },
  mounted(){
    eventBus.$on('popUp',this.openPopUp)
  },
  methods:{
    openPopUp(msg){
      this.popUpMsg = msg;
      this.active=true;
    },
    close(){
      this.active=false;
    }
  }

}

</script>
