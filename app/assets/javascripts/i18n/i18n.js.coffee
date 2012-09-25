###

Internationalisation

This script provides functionalities for internationalisation in JavaScript.
 
###

window.i18n.jed = new Jed {"domain": "leihs", locale_data: i18n.locale_data}

window._jed = (args...)->
  if typeof args[0] == "number"
    i18n.jed.translate(args[1]).ifPlural(args[0], args[2]).fetch args[3]
  else
    i18n.jed.translate(args[0]).fetch args[1]

jQuery ()->
  
  # set number format with accounting
  accounting.settings =
    currency:
      symbol: local_currency_string
      format: "%v %s"
      decimal: i18n.number.decimal
      thousand: i18n.number.thousand
      precision : 2
    number:
      precision: 0
      decimal: i18n.number.decimal
      thousand: i18n.number.thousand
    
  # set lang for moment js
  moment.lang "default",
    months : i18n.months.full
    monthsShort : i18n.months.trunc
    weekdays : i18n.days.full
    weekdaysShort : i18n.days.trunc
    longDateFormat :
      LT: i18n.time
      L : i18n.days.L
      LL : i18n.date.XL
      LLL : i18n.date.XXL
      LLLL : i18n.date.XXXL
    meridiem :
      AM : i18n.meridiem.AM
      am : i18n.meridiem.am
      PM : i18n.meridiem.PM
      pm : i18n.meridiem.pm
    calendar :
      sameDay: i18n.calendar.sameDay
      sameElse: i18n.calendar.sameElse
      nextDay: i18n.calendar.nextDay
      nextWeek: i18n.calendar.nextWeek
      lastDay: i18n.calendar.lastDay
      lastWeek: i18n.calendar.lastWeek
    relativeTime :
      future : i18n.relative.future
      past : i18n.relative.past
      s : i18n.relative.s
      m : i18n.relative.m
      mm : i18n.relative.mm
      h : i18n.relative.h
      hh : i18n.relative.hh
      d : i18n.relative.d
      dd : i18n.relative.dd
      M : i18n.relative.M
      MM : i18n.relative.MM
      y : i18n.relative.y
      yy : i18n.relative.yy
    ordinal : (number)-> "."
