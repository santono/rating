<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<template id="template-ntr-table">
    <div>
<%--
        <div class="ui breadcrumb" id="breadcrumbh">

        </div>
--%>
        <h3>Перечень научно-технических работ</h3>
		<p v-if="isadmin">{{namepre}}</p>
        <p v-show="isFilter">
           <span v-show="needYear">
               c {{yearFr}} по {{yearTo}}
           </span>
           <span v-show="needNPR">
               {{fioNprFilter}}
           </span>
        </p>
        <table class="ui selectable celled striped very compact table">
            <thead>
            <tr>
                <th v-on:click.prevent="sortntr('id')"># <i class="chevron up icon" v-if="currentSort=='id' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='id' && currentSortDir=='desc'"></i></th>
                <th v-if="isadmin" v-on:click.prevent="sortntr('auth')">Авторы <i class="chevron up icon" v-if="currentSort=='auth' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='auth' && currentSortDir=='desc'"></i></th>
                <th v-if="isnpr"   v-on:click.prevent="sortntr('coauth')">Соавторы <i class="chevron up icon" v-if="currentSort=='coauth' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='coauth' && currentSortDir=='desc'"></i></th>
                <th v-on:click.prevent="sortntr('name')">Название <i class="chevron up icon" v-if="currentSort=='name' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='name' && currentSortDir=='desc'"></i></th>
<%--            <th>Издание</th>       --%>
                <th v-if="isadmin" v-on:click.prevent="sortntr('predp')">Предпр. <i class="chevron up icon" v-if="currentSort=='predp' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='predp' && currentSortDir=='desc'"></i></th>
                <th>Х-ка</th>
                <th v-on:click.prevent="sortntr('approve')">Пдтв. <i class="chevron up icon" v-if="currentSort=='approve' && currentSortDir=='asc'"></i><i class="chevron down icon" v-if="currentSort=='approve' && currentSortDir=='desc'"></i></th>
                <th>Док.</th>
                <th>
                    <nobr>
                    <div v-on:click="showfilter" class="compact mini ui icon button" data-tooltip="Установить фильтр записей" data-position="bottom right">
                        <i class="filter icon"></i>
                    </div>
                    <div v-on:click="addrec" class="compact mini ui icon button" data-tooltip="Добавить работу" data-position="bottom right">
                        <i class="add icon"></i>
                    </div>
                    </nobr>
                </th>
            </tr>
            </thead>
            <tbody id="idtbodyntr">

            <tr is="ntrrow" v-for="(item,index) in ntrlist"
                            v-bind:rowrec       = "item"
                            :index              = "index"
                            :key                = "item.id"
                            v-on:editrec        = "editrec"
                            v-on:delrec         = "deleterec"
                            v-on:approvedrec    = "approvedrec"
                            v-on:disapprovedrec = "disapprovedrec" >
            </tr>
            </tbody>
            <tfoot v-if="pager.amntofpage>1">
            <tr>
                <th colspan="6">
                    <div class="ui right floated pagination menu">
                        <a class="icon item" v-on:click.prevent="goPrevPage()" v-bind:class="{disabled:pager.leftangle.disabled}" v-if="pager.leftangle.visible">
                            <i class="left chevron icon"></i>
                        </a>
                        <a class="item" v-on:click.prevent="goPage(pageitem.page)" v-for="(pageitem,index) in pager.pages" v-bind:class="{disabled:pageitem.disabled}" >
                            {{pageitem.page}}
                        </a>
                        <%--
                                                   <a class="item">1</a>
                                                   <a class="item">2</a>
                                                   <a class="item">3</a>
                                                   <a class="item">4</a>
                        --%>
                        <a class="icon item" v-on:click.prevent="goNextPage()" v-bind:class="{disabled:pager.rightangle.disabled}" v-if="pager.rightangle.visible">
                            <i class="right chevron icon"></i>
                        </a>
                    </div>
                </th>
            </tr>
            </tfoot>
        </table>

        <ntrform v-bind:receivedrec    = 'selectedrec'
                 v-bind:show.sync      = "showModal"
                 v-bind:receivedaction = "action"
                 v-on:eshowmodal       = "setEShowModal"
                 v-on:edelrec          = "eDelRec" >

        </ntrform>

        <div class="ui large modal" id="filtermodal">
            <div class="ui header">
                Фильтр научных работ
            </div>
            <div class="content">
                <div class="ui form" id="filterform">
                    <div class="inline fields">
                        <label v-if="needYear">C</label>
                        <div class="field" v-if="needYear">
                            <input v-model="yearFr" placeholder="Начальный год диапазона" type="number" step="1" max="2018" min="1960">
                        </div>
                        <label v-if="needYear">по</label>
                        <div class="field" v-if="needYear">
                            <input v-model="yearTo" placeholder="Конечный год диапазона" type="number" step="1" max="2018" min="1960">
                        </div>
                        <div class="field">
                            <div class="ui checkbox" id="cbNeedYear">
                                <input v-model="needYear" class="hidden" type="checkbox">
                                <label>Установить диапазон дат</label>
                            </div>
                        </div>                        
                    </div>

                    <div v-if="isadmin" class="inline fields">
<%--
                        <div v-show="needNPR" class="ui search selection dropdown twelve wide field" id="authorddb">
--%>
                        <div v-show="needNPR" class="ui search selection dropdown field " id="authorddb">
                            <input v-on:blur="addAuthor(author)"
                                   v-on:keyup.enter="addAuthor(author)"
                                   name="author" type="hidden" v-model="shifrNpr">
                            <i class="dropdown icon"></i>
                            <div class="default text">Автор</div>
                            <input type="text" class="search">
                        </div>
<%--
                        <div class="four wide field" >
--%>
                        <div class="field" >
                            <div class="ui checkbox" id="cbNeedNPR">
                                <input v-model="needNPR" class="hidden" type="checkbox">
                                <label>Выбрать автора</label>
                            </div>
                        </div>
                    </div>

                    <div v-if="isadmin" class="inline fields">
<%--
                        <div class="field" v-show="needPredp">
--%>
                    <div class="field">
                        <div>
                            <podrselector ref='podrslctr' v-bind:podrid  = "shifrPredp"
                                          v-on:eselpodr  = "ePodrSelected"
                                          v-on:enamepodr = "eNamePodr"></podrselector>

<%--
                        </div>
                        <div class="ui message">
--%>
                            <p v-cloak>{{namePodr}}</p>
                        </div>
                        </div>
                        <div class="field" >
                            <div class="ui checkbox" id="cbNeedPredp">
                                <input v-model="needPredp" class="hidden" type="checkbox">
                                <label>Выбрать подразделение</label>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
            <div class="actions">
                  <div class="ui positive right labeled icon button">
                      Установить фильтр
                    <i class="checkmark icon"></i>
                  </div>
                 <div class="ui negative button">Сбросить фильтр</div>
            </div>
        </div>
        
    </div>
</template>
<script>
    var ntrtable=Vue.extend({
        template: '#template-ntr-table',

        data:function() {
            return {ntrlist       :  null,
                    selectedrec   :    {},
                    selectedindex :    -1,
                    showModal     : false,
					namepre       :    "", 
					shifrpre      :     0,
                    shifrnpr      :     0,
                    action        :     0,
                    isnpr         :     false,
                    isadmin       :     false,
                    pager         : {
                        pagesize     : 10,
                        pageno       :  1,
                        amntofpage   :  1,
                        startvisiblepage    : 1,
                        amntofvisiblepages  : 5,
                        limitamntofvisiblepages  : 5,
                        leftangle    : {visible:false,disabled:true} ,
                        rightangle   : {visible:false,disabled:true} ,
                        pages        : []
                    },
                    currentSort     : 'auth'  ,
                    currentSortDir  : 'asc'   ,
                    currentSortCode : 1       ,
                    fioNprFilter    : ''
            };

        },
        components: {
            'ntrrow'       : ntrrow  ,
            'ntrform'      : ntrform ,
            'podrselector' : podrselector
        },
        computed : {
            yearFr:{
                get: function () {
                    return this.$root.ntrFilter.yearFr;
                },
                set: function (v) {
                    this.$root.ntrFilter.yearFr = v;
                }
            },
            yearTo:{
                get: function () {
                    return this.$root.ntrFilter.yearTo;
                },
                set: function (v) {
                    this.$root.ntrFilter.yearTo = v;
                }
            },
            needYear:{
                get: function () {
                    return this.$root.ntrFilter.needYear;
                },
                set: function (v) {
                    this.$root.ntrFilter.needYear = v;
                }
            },
            shifrNpr:{
                get: function () {
                    return this.$root.ntrFilter.shifrNpr;
                },
                set: function (v) {
                    this.$root.ntrFilter.shifrNpr = v;
                }
            },
            needNPR:{
                get: function () {
                    return this.$root.ntrFilter.needNPR;
                },
                set: function (v) {
                    this.$root.ntrFilter.needNPR = v;
                }
            },
            shifrPredp:{
                get: function () {
                    return this.$root.ntrFilter.shifrPredp;
                },
                set: function (v) {
                    this.$root.ntrFilter.shifrPredp = v;
                }
            },
            needPredp:{
                get: function () {
                    return this.$root.ntrFilter.needPredp;
                },
                set: function (v) {
                    this.$root.ntrFilter.needPredp = v;
                }
            },
            namePodr:{
                get: function () {
                    return this.$root.ntrFilter.namePredp;
                },
                set: function (v) {
                    this.$root.ntrFilter.namePredp = v;
                }
            },
            isFilter:function() {
                var retVal=false;
                if (this.needNPR || this.needYear) {
                    retVal=true;
                }
                return retVal;
            }
        },
        methods: {
            addAuthor: function () {
                var id=$('#authorddb').dropdown("get value");
//                alertify.alert('id='+id);
                if (!id || (id<1)) return;

                var value = id;
                if (!value) {
                    return
                }
                this.shifrNpr=value;
            },

            setAuthorsDD:function() {
                var l=$('#authorddb').length;
//                alertify.alert('inside init setAuthorsDD l='+l);
                if ($('#authorddb').length>0) {
                    var uri = this.$root.rootPath
                            + "/util/semanticui/dropdown/tags/{query}";
//                    alertify.alert('inside setAuthorsDD ');
                    $('#authorddb').dropdown({
                        apiSettings: {
                            // this url parses query server side and returns filtered results
                            url: uri
                        }
                    })
                    ;
//                    if ($('#cb').length>0) {
//                        $('#cb')
//                                .checkbox()
//                        ;
//                    }
                }
            },

            setEShowModal : function(newVal,newRec) {
//                console.log('ntrtable: inside setEShowModal');
                this.showModal=newVal;
                if (newRec) {
                    if (!_.isEqual(this.selectedrec,newRec)) {
                        this.selectedrec=_.clone(newRec);
                        if (this.isnpr) {
                            this.getNtrList(1,this.shifrnpr);
                        }
                        else {
                            this.getNtrList(0,this.shifrpre);
                        }

//                        console.log(JSON.stringify(this.selectedrec));
                    }
//                    if (this.selectedindex>=0)
//                        this.getAuthorListForNtr(this.selectedrec.id);
//                    if (this.action==1)
//                        this.eAddRec(newRec);

                }
            },
            finishEShowModalForPokaz:function(value) {
//                console.log('amntOfImages='+this.selectedrec.amntOfImages+" amntOfDocs="+this.selectedrec.amntOfDocs);
                this.selectedrec.authors=value;
                this.getPokazListForNtr(this.selectedrec.id);
            },
            finishEShowModal:function(value) {
//                console.log('amntOfImages='+this.selectedrec.amntOfImages+" amntOfDocs="+this.selectedrec.amntOfDocs);
                this.selectedrec.pokaz=value;
//                this.selectedrec.amntOfImages=this.countImages();
                var vm=this;
                this.$nextTick(function () {
                    if (vm.selectedindex>=0)
                        Vue.set(vm.ntrlist,vm.selectedindex,vm.selectedrec);
                });
            },
<%--
            setEShowModalFinish : function(value) {
                this.$nextTick(function () {
                    this.selectedrec.authors=value;
                    if (this.selectedindex>=0)
                         Vue.set(this.ntrlist,this.selectedindex,this.selectedrec);
                    });
            },
--%>
            eAddRec:function(newRec) {
                if (newRec) {
                    this.ntrlist.push(newRec);
                    this.performSortingNtr();
                }
            },
            eDelRec:function(newRec) {
//                if (this.selectedindex!=undefined)
//                    if (this.selectedindex>=0) {
//                    this.ntrlist.splice(this.selectedindex,1);
//                    this.performSortingNtr();
//                }
                if (this.isnpr) {
                    this.getNtrList(1,this.shifrnpr);
                }
                else {
                    this.getNtrList(0,this.shifrpre);
                }

            },
            editrec:function(currrec,index) {
//                console.log('ntrtable: editrec ='+JSON.stringify(currrec));
                this.selectedrec   = null;
                this.selectedrec   = currrec;
                this.selectedindex = index;
                this.action        = 2;
                this.showModal     = true;
            },
            deleterec:function(currrec,index) {

                this.selectedrec   = currrec;
                this.selectedindex = index;
                vm=this;
                if (currrec) {
                    alertify.confirm('Запрос на удаление', 'Удалить запись НТР '+currrec.id
                            , function(){ vm.deleteEntity(currrec.id); }
                            , function(){ /*alertify.error('Cancel')*/})
                            .set('labels', {ok:'Удалить', cancel:'Нет'})
                            .set({transition:'flipy'});
                }
            },
            addrec:function() {
                this.selectedrec            = {};
                this.selectedrec.id         =  0;
                this.selectedrec.authors    = "";
                this.selectedrec.name       = "";
                this.selectedrec.parametry  = "";
                this.selectedrec.amntOfImages = 0;
                this.selectedrec.amntOfDocs   = 0;
//                this.selectedrec.ownerid    = 0;
                this.selectedindex          = null;
                this.action                 = 1;
                this.showModal              = true;
            },

            deleteRec: function(item){
                if (this.isnpr) {
                    this.getNtrList(1,this.shifrnpr);
                }
                else {
                    this.getNtrList(0,this.shifrpre);
                }

            },
            finishDelete:function() {
                this.deleteRec();
            },

            approvedrec:function(currrec,index,dataapproved) {
                this.selectedrec  = currrec;
                this.selectedindex = index;
                this.selectedrec.approved='Подтверждено';
                this.selectedrec.dataapproved=dataapproved;
//                console.log('inside ntrtable. approvedrec='+JSON.stringify(this.selectedrec));
                if (this.selectedindex>=0) {
//                    Vue.set(this.ntrlist,this.selectedindex,this.selectedrec);
                   var vm=this;
                   this.$nextTick(function () {
                       if (vm.selectedindex>=0)
                          vm.ntrlist[vm.selectedindex]=this.selectedrec;
   //                       Vue.set(vm.ntrlist,vm.selectedindex,vm.selectedrec);
                   });
                }

            },
            disapprovedrec:function(currrec,index) {
//                console.log('inside ntrtable. disapprovedrec='+JSON.stringify(currrec));
                this.selectedrec  = currrec;
                this.selectedindex = index;
                this.selectedrec.approved='';
                this.selectedrec.dataapproved='';
                if (this.selectedindex>=0)
                    Vue.set(this.ntrlist,this.selectedindex,this.selectedrec);
            },


            performCompareNtr: function(ntr1,ntr2) {
                var retVal=0;
                if (ntr1.lineno>ntr2.lineno) retVal=1;
                else 
                if (ntr1.lineno<ntr2.lineno) retVal=-1;
                return retVal;
            },
            setFilter:function() {
//                alertify.alert("inside-1 setFilter. needNPR="+this.needNPR+" shifrNpr="+this.shifrNpr);
//                console.log("inside-1 setFilter. needNpr="+this.needNPR+" shifrNpr="+this.shifrNpr);
                if (this.needNPR)
                   this.addAuthor();
//                alertify.alert("inside-2 setFilter. shifrNpr="+this.shifrNpr);
//                console.log("inside-2 setFilter. shifrNpr="+this.shifrNpr);
                var needRefresh=false;
                if (this.needYear || (this.needNPR && this.shifrNpr>0))
                    needRefresh=true;
                if (this.needNPR && this.shifrNpr>0) {
//                    alertify.alert("needRefresh NPR shifrNpr="+this.shifrNpr);
                    this.getFioNPR(this.shifrNpr);
                }
                if (needRefresh) {
                    this.pager.pageno=1;
                    if (this.isnpr) {
                        this.getNtrList(1,this.shifrnpr);
                    }
                    else
                    if (this.shifrNpr>0 && this.needNPR) {
                        this.getNtrList(0,this.shifrpre);
                    }
                    else {
                        this.getNtrList(0,this.shifrpre);
                    }
                }

            },
            reSetFilter:function() {
              var needRefresh=false;
                if (this.needYear) {
                    this.needYear=false;
                    needRefresh=true;
                }
                if (this.needNPR) {
                    this.needNPR=false;
                    needRefresh=true;
                }
                if (needRefresh) {
                   this.pager.pageno=1;
                    if (this.isnpr) {
                        this.getNtrList(1,this.shifrnpr);
                    }
                    else {
                        this.getNtrList(0,this.shifrpre);
                    }
                }
            },
            showfilter:function() {
              var vm=this;
              $('#filtermodal')
                .modal({
                  closable  : true,
                  onDeny    : function(){
//                       window.alert('Wait not yet!');
//                       return true;
                        vm.reSetFilter();
                  },
                  onApprove : function() {
                              vm.setFilter();
                  }
                })
               .modal('show')
              ;
            },
            ePodrSelected:function(id) {
                if (id && id>0 && this.shifrPredp!=id) {
                    this.shifrPredp=id;
                    this.$refs.podrslctr.getPodrCompoundName(id);
                }


            },
            eNamePodr:function(nameVal) {
                if (nameVal && _.isString(nameVal))
                    this.namePodr=nameVal;
            },

            performSortingNtr:function() {
               if (this.ntrlist)
               if (Array.isArray(this.ntrlist))
                  this.ntrlist.sort(this.performCompareNtr)
            },
            getNtrList:function(mode,shifritem) {
                this.getNtrPageList(mode,shifritem);
                return;
<%--
                var uri2=this.$root.rootPath+"/util";
                var uri3;
                if (!mode || mode==0) {
                    uri3     = uri2+"/ntrs";
                }
                else {
                    uri3     = uri2+"/ntrsnpr";
                }
                var uri4     = uri3+"/"+shifritem;
                var uri      = uri4;
                var vm       = this;
                var finished = false;
                vm.$nextTick(function () {
                    window.app.isLoadingContent=true;
                });

                axios.get(uri, {
                })
                        .then(function (response) {
                            finished=true;
                            vm.ntrlist=response.data;
							vm.performSortingNtr();
                            vm.$nextTick(function () {
                               window.app.isLoadingContent=false;
                            });
//                            for(var i=0;i<vt.ntrlist.length;i++)
//                               if (vt.ntrlist[i].id==4)
//                                  console.log('ntr 4='+JSON.stringify(vt.ntrlist[i]));
//                            alert('shifrpre='+vt.shifrpre+' amnt of user '+vt.userslist.length);
                        })

                        .catch(function (error) {
                            vm.$nextTick(function () {
                               window.app.isLoadingContent=false;
                            });
                    alertify.alert("Ошибка",'error reading ntrlist='+error);
                          finished=true;
                });
--%>
            },
            getNtrPageList:function(mode,shifritem) { // 0 - predp 1 - NPR
                var uri2=this.$root.rootPath+"/util";
                var kind;
                kind=mode?mode:0;
                if (kind>1) kind=0;
                if (kind<0) kind=0;
//                var uri3;
//                if (!mode || mode==0) {
//                    uri3     = uri2+"/ntrs";
//                }
//                else {
//                    uri3     = uri2+"/ntrsnpr";
//                }
                var uri3     = uri2+"/ntrs/"+kind;
                var uri4     = uri3+"/"+shifritem;
                var yfr      = 1960;
                var yto      = 2030;
                var currentYear = new Date().getUTCFullYear();
                yto = currentYear;
                if (this.needYear
                 && this.yearFr <= this.yearTo
                 && this.yearFr >  1960
                 && this.yearFr <= currentYear)  {
                    yfr=this.yearFr;
                    yto=this.yearTo;
                }
                var uri5     = uri4+"/"+yfr    ;
                var uri6     = uri5+"/"+yto    ;
                var uri7     = uri6+"/"+this.pager.pageno    ;
                var uri8     = uri7+"/"+this.pager.pagesize  ;
                var uri9     = uri8+"/"+this.currentSortCode ;
                var shifridnprfilter = 0 ;
                if (this.needNPR) {
                   shifridnprfilter = this.shifrNpr;
                }
                var uri10    = uri9   + "/" + shifridnprfilter ;
//                var uri11    = uri10  + "/0"; // not need count
                var uri      = uri10  ;
                var vm       = this  ;
                var finished = false ;
//                alertify.alert("shifritem="+shifritem+" pageno="+this.pager.pageno+" pagesize="+this.pager.pagesize+" currentSordCode="+this.currentSortCode+" url="+uri);
//                return;
                vm.$nextTick(function () {
                    window.app.isLoadingContent=true;
                });

                axios.get(uri, {
                })
                        .then(function (response) {
                            finished=true;
                            vm.ntrlist=response.data;
//                            vm.performSortingNtr();
                            vm.getAmntOfPages(mode,shifritem);
                            vm.$nextTick(function () {
                                window.app.isLoadingContent=false;
                            });
//                            for(var i=0;i<vt.ntrlist.length;i++)
//                               if (vt.ntrlist[i].id==4)
//                                  console.log('ntr 4='+JSON.stringify(vt.ntrlist[i]));
//                            alert('shifrpre='+vt.shifrpre+' amnt of user '+vt.userslist.length);
                        })

                        .catch(function (error) {
                    vm.$nextTick(function () {
                        window.app.isLoadingContent=false;
                    });
                    alertify.alert("Ошибка",'error reading ntrlist='+error);
                    finished=true;
                });

            },
            getAmntOfPages:function(mode,shifritem) {  //mode=0 - предприятие =1 пользоватедь
                var uri3     = this.$root.rootPath+"/util/apntrs";
                var mode1    = mode?mode:0;
                 if (mode1>1)
                    mode1=0;
                var uri4      = uri3+"/"+shifritem+"/"+mode1;
                var yfr=1960;
                var yto=2030;
                var currentYear = new Date().getUTCFullYear();
                yto = currentYear;
                if (this.needYear
                        && this.yearFr <= this.yearTo
                        && this.yearFr >  1960
                        && this.yearFr <= currentYear)  {
                    yfr=this.yearFr;
                    yto=this.yearTo;
                }
                var uri5=uri4+"/"+yfr+"/"+yto;
                var shifridnprfilter=0;
                if (this.needNPR) {
                    shifridnprfilter=this.shifrNpr;
                }
                var uri6=uri5+"/"+shifridnprfilter;
                var uri=uri6;
                var vm       = this;
                var finished = false;
                axios.get(uri, {
                })
                        .then(function (response) {
                            finished=true;
                            vm.pager.amntofpage=response.data;
                            var ps=Math.floor (vm.pager.amntofpage / vm.pager.pagesize);
                            if ((vm.pager.amntofpage % vm.pager.pagesize)>0) {
                                ps++;
                            }
                            vm.pager.amntofpage=ps;
      //                      alertify.alert(" recs="+response.data+" aop="+vm.pager.amntofpage+" ps="+vm.pager.pagesize);
                            vm.setTableFooter();
//                            alert('shifrpre='+vt.shifrpre+' amnt of user '+vt.userslist.length);
                        })

                        .catch(function (error) {
                    alertify.alert('error reading amntofpage = '+error);
                    finished=true;
                });

            },
            deleteEntity: function(id) {
                var uri=this.$root.rootPath+"/util/ntr/del/"+id;
                var vm=this;
                axios.post(uri, {
                },{})
                        .then(function (response) {
                            var rec=JSON.stringify(response.data);
                            var rrec=JSON.parse(rec);
                            if (rrec[0].shifr=='Ok') {
                                vm.$nextTick(function () {
                                    vm.finishDelete();
                                    vm.$notify("alert", "Запись удалена.");
                                });
                            }
                            else {
                                alertify.alert("Ошибка", "Ошибка удаления НТР.");
                            }
                        })

                        .catch(function (error) {
                            alertify.alert("Ошибка", "error deleteEntity="+error);
                });
            },
            getPreName:function() {
                var uri = this.$root.rootPath+"/util/univ/"+this.shifrpre;
                var vm       = this;
                var finished = false;
                axios.get(uri, {
                })
                        .then(function (response) {
                            finished=true;
                            vm.namepre=response.data.name;
                        })

                        .catch(function (error) {
                    finished=true;
                });
                var i;
                while (finished) {
                    i=1;
                }
            },
            getAuthorListForNtr:function(id) {
                if (
                    (id==undefined) ||
                    (id<1)
                   ) {
                   this.finishEShowModalForPokaz("");
                   return;
                }
                var uri         = this.$root.rootPath+"/util/authorntr/"+id;
                var vm          = this;
                var authorsname = "";
                axios.get(uri, {
                })
                        .then(function (response) {
                            authorsname=response.data[0].name;
                            if (authorsname=='Empty')
                                authorsname="";
//                            console.log("inside success getaulist for ntr "+authorsname);
                            vm.finishEShowModalForPokaz(authorsname);
                        })
                        .catch(function (error) {
                              alertify.error("getAuthorListForNtr error="+error)
                     });

            },
            getPokazListForNtr:function(id) {
                if (
                        (id==undefined) ||
                                (id<1)
                        ) {
                    this.finishEShowModal("");
                    return;
                }
                var uri = this.$root.rootPath+"/util/pokazsntr/"+id;
                var vm         = this;
                var pokazsname = "";
                axios.get(uri, {
                })
                        .then(function (response) {
                            pokazsname=response.data[0].name;
                            if (pokazsname=='Empty')
                                pokazsname="";
//                            console.log("inside success getaulist for ntr "+authorsname);
                            vm.finishEShowModal(pokazsname);
                        })
                        .catch(function (error) {
                    alertify.error("getPokazListForNtr error="+error)
                });

            },
            getFioNPR: function(shifrid) {
                var uri=this.$root.rootPath+"/util/user/fio/"+shifrid;
                var vm=this;
                axios.get(uri, {
                })
                        .then(function (response) {
                            var rrec=response.data[0];
                            vm.$nextTick(function () {
                                vm.fioNprFilter=rrec.name;
                            });
                        })

                        .catch(function (error) {
                    alertify.alert("Ошибка","error getFioNPR=",error);
                });
            },

            goPage:function(pageNo) {
                if (pageNo == this.pager.pageno)
                    return;
                if (pageNo<1) return;
                if (pageNo>this.pager.amntofpage) return;
                this.pager.pageno = pageNo;
                if (this.isnpr) {
                    this.getNtrPageList(1,this.shifrnpr);
                }
                else {
                    this.getNtrPageList(0,this.shifrpre);
                }
            },
            goPrevPage:function() {
                if (this.pager.pageno<2) return;
                var wantedPage;
                wantedPage = this.pager.pageno-1;
                this.goPage(wantedPage);
            },
            goNextPage:function() {
                if (this.pager.pageno>=this.pager.amntofpage) return;
                var wantedPage;
                wantedPage = this.pager.pageno+1;
                this.goPage(wantedPage);
            },
            sortntr:function(s) {
                //if s == current sort, reverse
//                console.log('sortuser s='+s+' this.currentSort='+this.currentSort+' this.currentSortDir='+this.currentSortDir);
                if(s === this.currentSort) {
                    this.currentSortDir = this.currentSortDir==='asc'?'desc':'asc';
                }
                this.currentSort = s;
                if (this.currentSort=='auth' && this.currentSortDir=='asc') {
                    this.currentSortCode=1;
                    this.ntrlist=_.orderBy(this.ntrlist, 'authors', 'asc');
                }
                else
                if (this.currentSort=='auth' && this.currentSortDir=='desc') {
                    this.currentSortCode=11;
                    this.ntrlist=_.orderBy(this.ntrlist, 'authors', 'desc');
                }
                else
                if (this.currentSort=='coauth' && this.currentSortDir=='asc') {
                    this.currentSortCode=2;
                    this.ntrlist=_.orderBy(this.ntrlist, 'authors', 'asc');
                }
                else
                if (this.currentSort=='coauth' && this.currentSortDir=='desc') {
                    this.currentSortCode=12;
                    this.ntrlist=_.orderBy(this.ntrlist, 'authors', 'desc');
                }
                else
                if (this.currentSort=='name' && this.currentSortDir=='asc') {
                    this.currentSortCode=3;
                    this.ntrlist=_.orderBy(this.ntrlist, 'name', 'asc');
                }
                else
                if (this.currentSort=='name' && this.currentSortDir=='desc') {
                    this.currentSortCode=13;
                    this.ntrlist=_.orderBy(this.ntrlist, 'name', 'desc');
                }
                else
                if (this.currentSort=='predp' && this.currentSortDir=='asc') {
                    this.currentSortCode=4;
                    this.ntrlist=_.orderBy(this.ntrlist, 'namepre', 'asc');
                }
                else
                if (this.currentSort=='predp' && this.currentSortDir=='desc') {
                    this.currentSortCode=14;
                    this.ntrlist=_.orderBy(this.ntrlist, 'namepre', 'desc');
                }
                else
                if (this.currentSort=='approve' && this.currentSortDir=='asc') {
                    this.currentSortCode=5;
                    this.ntrlist=_.orderBy(this.ntrlist, 'approved', 'asc');
                }
                else
                if (this.currentSort=='approve' && this.currentSortDir=='desc') {
                    this.currentSortCode=15;
                    this.ntrlist=_.orderBy(this.ntrlist, 'approved', 'desc');
                }
                else
                if (this.currentSort=='id' && this.currentSortDir=='asc') {
                    this.currentSortCode=6;
                    this.ntrlist=_.orderBy(this.ntrlist, 'id', 'asc');
                }
                else
                if (this.currentSort=='id' && this.currentSortDir=='desc') {
                    this.currentSortCode=16;
                    this.ntrlist=_.orderBy(this.ntrlist, 'id', 'desc');
                }
                else
                if (currentSortDir=='asc')
                    this.currentSortCode=0;
                else
                    this.currentSortCode=10;

            },
            setTableFooter:function() {
                <%--
                                if (this.pager.pageno<4)
                                    this.pager.startvisiblepage=1;
                                else
                                    this.pager.startvisiblepage=this.pager.pageno-2;
                                if (this.pager.amntofpage>4)
                                    this.pager.amntofvisiblepages=5;
                                else
                                    this.pager.amntofvisiblepages=this.pager.amntofpage;
                                if (this.startvisiblepage>1) this.pager.leftangle=true;
                --%>
//                console.log('setTableFooter: this.pager.amntofpage='+this.pager.amntofpage);
                this.pager.pages=[];
                this.pager.leftangle.visible   = false;
                this.pager.leftangle.disabled  = true;
                this.pager.rightangle.visible  = false;
                this.pager.rightangle.disabled = true;
                if (this.pager.amntofpage<2) {
                    return;
                }
                if (this.pager.amntofpage<this.pager.limitamntofvisiblepages) {
//                    console.log('setTableFooter1: this.pager.amntofpage='+this.pager.amntofpage);
                    this.pager.leftangle.visible   = true  ;
                    this.pager.leftangle.disabled  = false ;
                    this.pager.rightangle.visible  = true  ;
                    this.pager.rightangle.disabled = false ;
                    this.pager.amntofvisiblepages  = this.pager.amntofpage;
                    for (var i=0;i<this.pager.amntofvisiblepages;i++) {
                        this.pager.pages.push({page:i+1,disabled:i+1==this.pager.pageno?true:false});
                    }
//                    console.log('setTableFooter2: ');
//                    for (var i=0;i<this.pager.pages.length;i++)
//                        console.log(JSON.stringify(this.pager.pages[i]));
                    return
                }
                if (this.pager.pageno>=(this.pager.amntofpage-this.pager.limitamntofvisiblepages+1)) {
                    this.pager.leftangle.visible   = true  ;
                    this.pager.leftangle.disabled  = false ;
                    if (this.pager.pageno<this.pager.amntofpage) {
                        this.pager.rightangle.visible  = true  ;
                        this.pager.rightangle.disabled = false ;
                    }
                    else {
                        this.pager.rightangle.visible  = false ;
                        this.pager.rightangle.disabled = true  ;
                    }
                    this.pager.amntofvisiblepages = this.pager.limitamntofvisiblepages;
                    this.pager.startvisiblepage   = this.pager.amntofpage-this.pager.limitamntofvisiblepages+1;
                    for (var i=0;i<this.pager.amntofvisiblepages;i++) {
                        this.pager.pages.push({page:this.pager.startvisiblepage+i,disabled:this.pager.startvisiblepage+i==this.pager.pageno?true:false});
                    }
//                    console.log('setTableFooter2: ');
//                    for (var i=0;i<this.pager.pages.length;i++)
//                        console.log(JSON.stringify(this.pager.pages[i]));
                    return
                }
                var l=Math.floor(this.pager.limitamntofvisiblepages /2);
                if (this.pager.pageno>l)
                    this.pager.startvisiblepage=this.pager.pageno-l;
                else
                    this.pager.startvisiblepage=1;
                this.pager.amntofvisiblepages=this.pager.limitamntofvisiblepages;
                for (var i=0;i<this.pager.amntofvisiblepages;i++) {
                    this.pager.pages.push({page:this.pager.startvisiblepage+i,disabled:this.pager.startvisiblepage+i==this.pager.pageno?true:false});
                }
                if (this.pager.pageno>1) {
                    this.pager.leftangle.visible=true;
                    this.pager.leftangle.disabled=false;
                }
                if (this.pager.pageno<this.pager.amntofpage) {
                    this.pager.rightangle.visible=true;
                    this.pager.rightangle.disabled=false;
                }
                return;
            }
        },
        mounted:function () {
            var vm=this;
            this.$nextTick(function () {
                $('.ui.sidebar').sidebar('toggle');
                $("#startcard").hide();
                var h = window.innerHeight;
                $('#idtbodyntr').css('height',h);
                $('#idtbodyntr').css('overflowY','scroll');
                $('#cbNeedYear')
                        .checkbox()
                ;
                $('#cbNeedNPR')
                        .checkbox()
                ;
                $('#cbNeedPredp')
                        .checkbox()
                ;

                vm.setAuthorsDD();
            });
        },
<%--
        beforeRouteUpdate:function(to, from, next) {
            var vm=this;
            this.$nextTick(function () {
                vm.shifrpre = this.$route.params.id;
                vm.isnpr    = window.user.isNPR();
                vm.isadmin  = window.user.isAdmin();
                vm.getPreName();
//                vm.getNtrList();
                console.log('--- B A D --- setted isadmin in beforeRouteUpdate');
            });
            next();
         },
--%>
        created: function() {
            this.shifrpre = this.$route.params.id;
            this.userid   = this.$route.params.iduser;
            var userRole  = this.$route.params.idrole;
            this.getPreName();
            if (userRole==1) {
                this.isnpr    = true;
                this.shifrnpr = this.userid;
                this.isadmin  = false;
            }
            else
            if (userRole==2) {
                this.isnpr    = false;
                this.shifrnpr = 0;
                this.isadmin  = true;
            }
            else {
                this.isnpr    = false;
                this.shifrnpr = 0;
                this.isadmin  = false;
            }

            if (this.isnpr) {
                this.getNtrList(1,this.shifrnpr);
            }
            else {
                this.getNtrList(0,this.shifrpre);
            }
        },
        beforeCreate:function() {
            var l=$( "#modalntr" ).length;
            if (l>0) {
                $( "#modalntr" ).remove();
            }

        }

    });

</script>