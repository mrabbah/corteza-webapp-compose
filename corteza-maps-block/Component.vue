<template>
  <wrap
    v-bind="$props"
    v-on="$listeners"
  >
    <div id="container">
      <div
        :id="idmap"
        style="height: 100vh; width: 100vw;"
      />
    </div>
     <div>{{options.datasource}}</div>
  </wrap>
 
</template>

<script>
import { mapGetters } from 'vuex'
import base from './base'
import users from 'corteza-webapp-compose/src/mixins/users'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'
// import axios from 'axios'

export default {
  i18nOptions: {
    namespaces: 'block',
  },

  components: {},

  extends: base,

  mixins: [users],

  data () {
    return {
      map: null,
      mar: null,
      zoom: 2,
      iconWidth: 25,
      iconHeight: 40,
      marker: [-0, 0],
      idmap: 'map-' + new Date().getTime(),
    }
  },

  computed: {
    ...mapGetters({
      getModuleByID: 'module/getByID',
      pages: 'page/set',
      findByID: 'user/findByID',
    }),

    roModule () {
      return this.getModuleByID(this.moduleID)
    },

    moduleID () {
      return this.options.moduleID
    },
  },

  mounted: function () {
    //  //document.cookie = 'JSESSIONID=node0oeeih2kk5cy116s6jaa6nuu7o399.node0 ; path=/';
    //  var ws = new WebSocket("ws://172.17.0.1/wsapp");

    //  ws.onopen = function(s) {

    //     // Web Socket is connected, send data using send()
    //     //ws.send("Message to send");
    //     //alert("Message is sent...");
    //      console.log(s)
    //  };

    //  ws.onmessage = function (evt) {
    //     var received_msg = evt.data;
    //   console.log(received_msg)
    //  };

    //  ws.onclose = function(s) {

    //     console.log(s)
    //  };

    //  ws.onerror = function(s){

    //     console.log(s)
    //  };

    const mapDiv = L.map(this.idmap, {
      center: [33.5934641, -7.6079437],
      zoom: 13,
    })

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution:
        'Map data (c) <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, <a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery (c) <a href="https://www.mapbox.com/">Mapbox</a>',
      maxZoom: 18,
    }).addTo(mapDiv)

    this.map = mapDiv

    this.updatePosts()
  },
  methods: {
    updatePosts: function () {
      /**
      const params = new URLSearchParams()
      params.append('email', 'a@a2')
      params.append('password', 'aa')

     var config = {
        method: 'post',
        url: '/traccar/sessions/',
        headers: {
          'Authorization': 'Basic YUBhMi5jb206YWE=',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        data : {
          "email":"a@a2",
          "password":"aa"
          }
        };

      Axios(config)
      .then(function (response) {
          console.log(JSON.stringify(response.data));
      })
 */

      // fetch("http://demo.traccar.org/api/positions")
      // this.marker[1]=data[0]['longitude']
      // this.marker[0]=data[0]['latitude']

      // if (!this.mar) this.mar = L.marker(this.marker).addTo(this.map)
      // this.mar.setLatLng(this.marker)
      //  self.$http.get('api/posts', function(responce, status, request) {
      //  self.posts = responce.data;
      // setTimeout(
      //   function () {
      //     this.updatePosts()
      //   }.bind(this),
      //   1000,
      // )
      // });
    },
    log (a) {
      console.log(a)
    },
  },
}
</script>

<style lang="scss" scoped>
.grab {
  cursor: grab;
}

#map {
  height: 100vh;
  width: 100vw;
}
</style>
