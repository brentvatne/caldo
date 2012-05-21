/* Moment.js | version : 1.4.0 | author : Tim Wood | license : MIT */
(function(a,b){function r(a){this._d=a}function s(a,b){var c=a+"";while(c.length<b)c="0"+c;return c}function t(b,c,d,e){var f=typeof c=="string",g=f?{}:c,h,i,j,k;return f&&e&&(g[c]=+e),h=(g.ms||g.milliseconds||0)+(g.s||g.seconds||0)*1e3+(g.m||g.minutes||0)*6e4+(g.h||g.hours||0)*36e5,i=(g.d||g.days||0)+(g.w||g.weeks||0)*7,j=(g.M||g.months||0)+(g.y||g.years||0)*12,h&&b.setTime(+b+h*d),i&&b.setDate(b.getDate()+i*d),j&&(k=b.getDate(),b.setDate(1),b.setMonth(b.getMonth()+j*d),b.setDate(Math.min((new a(b.getFullYear(),b.getMonth()+1,0)).getDate(),k))),b}function u(a){return Object.prototype.toString.call(a)==="[object Array]"}function v(b){return new a(b[0],b[1]||0,b[2]||1,b[3]||0,b[4]||0,b[5]||0,b[6]||0)}function w(b,d){function u(d){var e,j;switch(d){case"M":return f+1;case"Mo":return f+1+q(f+1);case"MM":return s(f+1,2);case"MMM":return c.monthsShort[f];case"MMMM":return c.months[f];case"D":return g;case"Do":return g+q(g);case"DD":return s(g,2);case"DDD":return e=new a(h,f,g),j=new a(h,0,1),~~((e-j)/864e5+1.5);case"DDDo":return e=u("DDD"),e+q(e);case"DDDD":return s(u("DDD"),3);case"d":return i;case"do":return i+q(i);case"ddd":return c.weekdaysShort[i];case"dddd":return c.weekdays[i];case"w":return e=new a(h,f,g-i+5),j=new a(e.getFullYear(),0,4),~~((e-j)/864e5/7+1.5);case"wo":return e=u("w"),e+q(e);case"ww":return s(u("w"),2);case"YY":return s(h%100,2);case"YYYY":return h;case"a":return m>11?t.pm:t.am;case"A":return m>11?t.PM:t.AM;case"H":return m;case"HH":return s(m,2);case"h":return m%12||12;case"hh":return s(m%12||12,2);case"m":return n;case"mm":return s(n,2);case"s":return o;case"ss":return s(o,2);case"zz":case"z":return(b.toString().match(l)||[""])[0].replace(k,"");case"Z":return(p>0?"+":"-")+s(~~(Math.abs(p)/60),2)+":"+s(~~(Math.abs(p)%60),2);case"ZZ":return(p>0?"+":"-")+s(~~(10*Math.abs(p)/6),4);case"L":case"LL":case"LLL":case"LLLL":case"LT":return w(b,c.longDateFormat[d]);default:return d.replace(/(^\[)|(\\)|\]$/g,"")}}var e=new r(b),f=e.month(),g=e.date(),h=e.year(),i=e.day(),m=e.hours(),n=e.minutes(),o=e.seconds(),p=-e.zone(),q=c.ordinal,t=c.meridiem;return d.replace(j,u)}function x(b,d){function p(a,b){var d;switch(a){case"M":case"MM":e[1]=~~b-1;break;case"MMM":case"MMMM":for(d=0;d<12;d++)if(c.monthsParse[d].test(b)){e[1]=d;break}break;case"D":case"DD":case"DDD":case"DDDD":e[2]=~~b;break;case"YY":b=~~b,e[0]=b+(b>70?1900:2e3);break;case"YYYY":e[0]=~~Math.abs(b);break;case"a":case"A":l=b.toLowerCase()==="pm";break;case"H":case"HH":case"h":case"hh":e[3]=~~b;break;case"m":case"mm":e[4]=~~b;break;case"s":case"ss":e[5]=~~b;break;case"Z":case"ZZ":h=!0,d=(b||"").match(o),d&&d[1]&&(f=~~d[1]),d&&d[2]&&(g=~~d[2]),d&&d[0]==="+"&&(f=-f,g=-g)}}var e=[0,0,1,0,0,0,0],f=0,g=0,h=!1,i=b.match(n),j=d.match(m),k,l;for(k=0;k<j.length;k++)p(j[k],i[k]);return l&&e[3]<12&&(e[3]+=12),l===!1&&e[3]===12&&(e[3]=0),e[3]+=f,e[4]+=g,h?new a(a.UTC.apply({},e)):v(e)}function y(a,b){var c=Math.min(a.length,b.length),d=Math.abs(a.length-b.length),e=0,f;for(f=0;f<c;f++)~~a[f]!==~~b[f]&&e++;return e+d}function z(a,b){var c,d=a.match(n),e=[],f=99,g,h,i;for(g=0;g<b.length;g++)h=x(a,b[g]),i=y(d,w(h,b[g]).match(n)),i<f&&(f=i,c=h);return c}function A(a,b,d){var e=c.relativeTime[a];return typeof e=="function"?e(b||1,!!d,a):e.replace(/%d/i,b||1)}function B(a,b){var c=d(Math.abs(a)/1e3),e=d(c/60),f=d(e/60),g=d(f/24),h=d(g/365),i=c<45&&["s",c]||e===1&&["m"]||e<45&&["mm",e]||f===1&&["h"]||f<22&&["hh",f]||g===1&&["d"]||g<=25&&["dd",g]||g<=45&&["M"]||g<345&&["MM",d(g/30)]||h===1&&["y"]||["yy",h];return i[2]=b,A.apply({},i)}function C(a,b){c.fn[a]=function(a){return a!=null?(this._d["set"+b](a),this):this._d["get"+b]()}}var c,d=Math.round,e={},f=typeof module!="undefined",g="months|monthsShort|monthsParse|weekdays|weekdaysShort|longDateFormat|calendar|relativeTime|ordinal|meridiem".split("|"),h,i=/^\/?Date\((\d+)/i,j=/(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|dddd?|do?|w[o|w]?|YYYY|YY|a|A|hh?|HH?|mm?|ss?|zz?|ZZ?|LT|LL?L?L?)/g,k=/[^A-Z]/g,l=/\([A-Za-z ]+\)|:[0-9]{2} [A-Z]{3} /g,m=/(\\)?(MM?M?M?|dd?d?d|DD?D?D?|YYYY|YY|a|A|hh?|HH?|mm?|ss?|ZZ?|T)/g,n=/(\\)?([0-9]+|([a-zA-Z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+|([\+\-]\d\d:?\d\d))/gi,o=/([\+\-]|\d\d)/gi,p="1.4.0",q="Month|Date|Hours|Minutes|Seconds|Milliseconds".split("|");c=function(c,d){if(c===null)return null;var e,f;return c&&c._d instanceof a?e=new a(+c._d):d?u(d)?e=z(c,d):e=x(c,d):(f=i.exec(c),e=c===b?new a:f?new a(+f[1]):c instanceof a?c:u(c)?v(c):new a(c)),new r(e)},c.version=p,c.lang=function(a,b){var d,h,i,j=[];if(b){for(d=0;d<12;d++)j[d]=new RegExp("^"+b.months[d]+"|^"+b.monthsShort[d].replace(".",""),"i");b.monthsParse=b.monthsParse||j,e[a]=b}if(e[a])for(d=0;d<g.length;d++)h=g[d],c[h]=e[a][h]||c[h];else f&&(i=require("./lang/"+a),c.lang(a,i))},c.lang("en",{months:"January_February_March_April_May_June_July_August_September_October_November_December".split("_"),monthsShort:"Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),weekdays:"Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),weekdaysShort:"Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),longDateFormat:{LT:"h:mm A",L:"MM/DD/YYYY",LL:"MMMM D YYYY",LLL:"MMMM D YYYY LT",LLLL:"dddd, MMMM D YYYY LT"},meridiem:{AM:"AM",am:"am",PM:"PM",pm:"pm"},calendar:{sameDay:"[Today at] LT",nextDay:"[Tomorrow at] LT",nextWeek:"dddd [at] LT",lastDay:"[Yesterday at] LT",lastWeek:"[last] dddd [at] LT",sameElse:"L"},relativeTime:{future:"in %s",past:"%s ago",s:"a few seconds",m:"a minute",mm:"%d minutes",h:"an hour",hh:"%d hours",d:"a day",dd:"%d days",M:"a month",MM:"%d months",y:"a year",yy:"%d years"},ordinal:function(a){var b=a%10;return~~(a%100/10)===1?"th":b===1?"st":b===2?"nd":b===3?"rd":"th"}}),c.fn=r.prototype={clone:function(){return c(this)},valueOf:function(){return+this._d},"native":function(){return this._d},toString:function(){return this._d.toString()},toDate:function(){return this._d},format:function(a){return w(this._d,a)},add:function(a,b){return this._d=t(this._d,a,1,b),this},subtract:function(a,b){return this._d=t(this._d,a,-1,b),this},diff:function(a,b,e){var f=c(a),g=(this.zone()-f.zone())*6e4,h=this._d-f._d-g,i=this.year()-f.year(),j=this.month()-f.month(),k=this.date()-f.date(),l;return b==="months"?l=i*12+j+k/30:b==="years"?l=i+j/12:l=b==="seconds"?h/1e3:b==="minutes"?h/6e4:b==="hours"?h/36e5:b==="days"?h/864e5:b==="weeks"?h/6048e5:h,e?l:d(l)},from:function(a,b){var d=this.diff(a),e=c.relativeTime,f=B(d,b);return b?f:(d<=0?e.past:e.future).replace(/%s/i,f)},fromNow:function(a){return this.from(c(),a)},calendar:function(){var a=this.diff(c().sod(),"days",!0),b=c.calendar,d=b.sameElse,e=a<-6?d:a<-1?b.lastWeek:a<0?b.lastDay:a<1?b.sameDay:a<2?b.nextDay:a<7?b.nextWeek:d;return this.format(typeof e=="function"?e.apply(this):e)},isLeapYear:function(){var a=this.year();return a%4===0&&a%100!==0||a%400===0},isDST:function(){return this.zone()<c([this.year()]).zone()||this.zone()<c([this.year(),5]).zone()},day:function(a){var b=this._d.getDay();return a==null?b:this.add({d:a-b})},sod:function(){return this.clone().hours(0).minutes(0).seconds(0).milliseconds(0)},eod:function(){return this.sod().add({d:1,ms:-1})}};for(h=0;h<q.length;h++)C(q[h].toLowerCase(),q[h]);C("year","FullYear"),c.fn.zone=function(){return this._d.getTimezoneOffset()},f&&(module.exports=c),typeof window!="undefined"&&(window.moment=c),typeof define=="function"&&define.amd&&define("moment",[],function(){return c})})(Date)

