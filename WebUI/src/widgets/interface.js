export const requestInterface = (function(){
	return {
		first_name:null,
		last_name:null,
		from_airport:null,
		to_airport:null,
		booking_class:null,
		age_group:null,
		departure_date:null,
		return_date:null,
	}
})();
export const locateInterface = (function(){
	return {
		"DEL":{name:'New Delhi (DEL)',pic:'NewDelhi'},
		'MEL':{name:'Melbourne (MEL)',pic:'Melbourne'},
		'SYD':{name:'Sydney (SYD)',pic:'Sydney'},
		'SAN':{name:'San Fransisco (SFO)',pic:'SanFransisco'},
		'JFK':{name:'New York (JFK)',pic:'NewYork'},
		'LAX':{name:'Los Angeles (LAX)',pic:'LosAngeles'},
	};
})();

export function sleep(mil){
  var start = new Date().getTime();
  for (var i = 0; i < 1e7; i++) {
    if ((new Date().getTime() - start) > mil){
      break;
    }
  }
};
