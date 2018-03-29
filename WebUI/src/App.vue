<template>
  <div class="warpper">
    <section class="bookingWarp">
      <div class="bg_right">
         <div v-for="item of bg" v-bind:class="item.class" v-bind:style="'background-image:url('+item.src+')'"></div>
      </div>
      <div class="container">
        <div class="booking_flex">
          <img src="static/img/logo.png">
          <article class="booking_block">
            <form action="javascript:void(0)">
              <div class="half_block name">
                <div class="flex_1">
                  <input type="text"  v-model="req.first_name" placeholder="First name" required>
                </div>
                <div class="flex_1">
                  <input type="text" v-model="req.last_name" placeholder="Last name" required>
                </div>
              </div>
              <div class="full_block location">
                <div class="flex_1">
                  <span>From</span>
                  <select v-model="req.from_airport" required>
                    <option v-for="l,i of locate" v-if="req.to_airport!=i" v-bind:value="i">{{l.name}}</option>
                  </select>
                </div>
                <div class="flex_1">
                  <span><i class="fa fa-caret-right" aria-hidden="true"></i> To</span>
                  <select v-model="req.to_airport" required>
                    <option v-for="l,i of locate" v-if="req.from_airport!=i" v-bind:value="i">{{l.name}}</option>
                  </select>
                </div>
              </div>
              <div class="full_block">
                <div class="flex_1 cabin">
                  <span>Cabin Class</span>
                  <select v-model="req.booking_class" required>
                    <option value="Economy">Economy</option>
                    <option value="Business">Business</option>
                    <option value="Premium Economy">Premium Economy</option>
                    <option value="First Class">First Class</option>
                  </select>
                </div>
                <div class="flex_1 check_block">
                  <input type="text" v-model="req.age_group" class="hide" required>
                  <div v-bind:class="req.age_group=='Adult'?'flex_1 active':'flex_1'" v-on:click="ageGroupUpdate('Adult')">
                    <i v-bind:class="req.age_group=='Adult'?'fa fa-check-square-o':'fa fa-square-o'" aria-hidden="true"></i>
                    <span>Adult</span>
                  </div>
                  <div v-bind:class="req.age_group=='Child'?'flex_1 active':'flex_1'" v-on:click="ageGroupUpdate('Child')">
                    <i v-bind:class="req.age_group=='Child'?'fa fa-check-square-o':'fa fa-square-o'" aria-hidden="true"></i>
                    <span>Child</span>
                  </div>
                  <div v-bind:class="req.age_group=='Infant'?'flex_1 active':'flex_1'" v-on:click="ageGroupUpdate('Infant')">
                    <i v-bind:class="req.age_group=='Infant'?'fa fa-check-square-o':'fa fa-square-o'" aria-hidden="true"></i>
                    <span>Infant</span>
                  </div>
                </div>
              </div>
              <div class="full_block">
                <div class="flex_1">
                  <div class="date_block">
                    <input type="text" v-model="req.departure_date" class="hide" required>
                    <span>Departure<i class="fa fa-calendar" aria-hidden="true"></i></span>
                    <datepicker v-on:selected="updateDepartureDate" :required="true" :disabled="disabled.Return"></datepicker>
                  </div>
                  <div class="date_block">
                    <input type="text" v-model="req.return_date" class="hide" required>
                    <span>Return<i class="fa fa-calendar" aria-hidden="true"></i></span>
                    <datepicker v-on:selected="updateReturnDate" :required="true" :disabled="disabled.Departure"></datepicker>
                  </div>
                </div>
                <div class="flex_1">
                  <div class="submit_block">
                    <button v-on:click="submit">Submit<i class="fa fa-plane" aria-hidden="true"></i></button>
                  </div>
                </div>
              </div>
            </form>
          </article>
        </div>
      </div>
      <div class="colorBar">
        <span></span>
        <span></span>
        <span></span>
        <span></span>
        <span></span>
      </div>
    </section>
    <section class="bookingTable">
      <div class="container">
        <ul class="tableUl title">
          <li>Booking Number</li>
          <li>Name</li>
          <li>From</li>
          <li>To</li>
          <li>Departure</li>
          <li>Return</li>
          <li>Age Group</li>
          <li>Class</li>
          <li>Mileages</li>
        </ul>
        <div class="result_block">
          <ul class="tableUl" v-for="t of table">
            <li>{{t.booking_number}}</li>
            <li>{{t.first_name}} {{t.last_name}}</li>
            <li>{{t.from_airport}}</li>
            <li>{{t.to_airport}}</li>
            <li>{{formateDate(t.departure_date)}}</li>
            <li>{{formateDate(t.return_date)}}</li>
            <li>{{t.age_group}}</li>
            <li>{{t.booking_class}}</li>
            <li>{{t.airmile||''}}</li>
          </ul>
        </div>
      </div>
    </section>
    <popUp/>
  </div>
</template>

<script>
import Datepicker from 'vuejs-datepicker'
import popUp from './components/popUp'
import {requestInterface,locateInterface,sleep} from './widgets/interface'
import {eventBus} from './widgets/eventBus'
import {io} from './widgets/axios';
export default {
  name: 'app',
  data(){
    return{
      req:requestInterface,
      locate:locateInterface,
      disabled:{
        Departure:{to:null},
        Return:{from:null}
      },
      popUpMsg:'',
      bg:[],
      table:[],
    }
  },
  components: {
    Datepicker,popUp,
  },
  mounted(){
    this.initReq();
    this.updateTable();
  },
  methods:{
    initReq:function(){
      this.req.age_group = 'Adult';
    },
    ageGroupUpdate:function(opt){
      this.req.age_group = opt;
    },
    updateDepartureDate:function(date){
      this.req.departure_date = date;
      this.disabled.Departure.to = date;
    },
    updateReturnDate:function(date){
      this.req.return_date = date;
      this.disabled.Return.from = date;
    },
    picUpdate:function(){
      if(this.req.to_airport){
        this.goPicBgAnimate(this.locate[this.req.to_airport].pic);
      }
    },
    goPicBgAnimate:function(pic){
      const item = {class:'bg_item',src:'static/img/'+pic+'.jpg'};
      this.bg.push(item);
      setTimeout(()=>{
        let leng = this.bg.length
        this.bg.forEach((it,i)=>{
          if(i==leng-1){
            it.class='bg_item active';
          }else{
            it.class='bg_item';
          }
        });
        if(leng>10){
          this.bg.splice(0,8);
        }
      },20);
    },
    updateTable(){
      io.getTickets().then(r=>{
        this.table = r.data;
        this.getMilages();
      })
    },
    getMilages(){
      this.table.forEach((t,i)=>{
        sleep(100);
        io.getMileage(t.booking_number).then(r=>{
          console.log(r.data.data.airmiles);
          if(r.data.data.airmiles){
            this.$set(this.table[i],'airmile',r.data.data.airmiles);
          }
        });
      })
    },
    formateDate(date){
      let D = new Date(date);
      return D.toString("yyyy-MM-dd HH:mm"); 
    },
    submit:function(){
      io.postSubmit(this.req).then(r=>{
        this.updateTable();
        console.log(r.data);
        eventBus.$emit('popUp','Booking success: '+ r.data.booking_number);
      }).catch(e=>{
        eventBus.$emit('popUp','Booking faild');
      });
    }
  },
  watch:{
    'req.to_airport':{
      handler:function(){
        this.picUpdate();
      }
    }
  }
}

</script>
