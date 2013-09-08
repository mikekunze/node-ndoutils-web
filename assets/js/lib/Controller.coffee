class Controller

  constructor: ()->
    @view = 'index'
    @hosts = {}

    @displayView()
    @displayGlobalNavgation()
    @addGlobalClickEvents()
    @displayCarousel()

  displayView: ()->
    controller = @
    $.ajax
      url: '/api/view/getViewByName'
      data:
        name: @view
      success: (data)->
        if !data.html
          alert('unable to load view html for ' + controller.view)

        if data.err
          console.log data.err

        $("#bodyDiv").hide().html(data.html).fadeIn('slow')
      dataType: 'json'

    return @

  getServiceDetailsByHost: ()->
    controller = @
    $.ajax
      url: '/api/view/getServiceDetailsByHost'
      data:
        name: @view
      success: (data)->
        controller.hosts = data.hosts
        $("#overallDetailsDiv").hide().html(data.html).fadeIn('slow')
      dataType: 'json'

    return @

  displayGlobalNavgation: ()->
    $.ajax
      url: '/api/view/getGlobalNavigation'
      data:
        name: @view
      success: (data)->
        $("#globalNavigationDiv").html data.html
      dataType: 'json'

    return @

  displayCarousel: ()->
    $.ajax
      url: '/api/view/getCarousel'
      data:
        name: @view
      success: (data)->
        $("#carousel").hide().html(data.html).fadeIn('slow')
      dataType: 'json'

    return @

  addGlobalClickEvents: ()->
    controller = @

    $("#bodyDiv").on 'click', 'a', (e)->
      component = $(this).data("component")
      method    = $(this).data("method")

      switch component
        when "view"

          switch method
            when "getViewByName"
              $("#globalNavigationDiv a").parent().removeClass('active')

              if $("#carousel").is(":visible")
                $("#carousel").fadeOut('slow')

              controller.view = $(this).data("name")
              controller.displayView()

              if $(this).data("name") is "index"
                $("#carousel").fadeIn('slow')

              if $(this).data("name") is "about"
                $("#navAboutLink").parent().addClass('active')

        when "host"
          switch method
            when "showDetails"
              hostName = $(this).html()
              if hostName.indexOf(".") >= 0
                hostName = hostName.replace ".", "\\."

              if $("#hostDiv_#{hostName}").is(":visible")
                $("[id^=trHost_]").fadeIn('fast')
                $("#hostDiv_#{hostName}").hide()
              else
                $("[id^=trHost_]").fadeOut 'fast', ()->
                  $("#hostDiv_#{hostName}").removeClass('hide').hide().fadeIn('fast')
                  $("#trHost_#{hostName}").removeClass('hide').fadeIn('fast')

            when "showAllHosts"
              $("[id^=hostDiv_]").fadeOut("fast")
              $("[id^=trHost_]").fadeIn('fast')

    $("#carousel").on 'click', 'a', (e)->
      component = $(this).data("component")
      method    = $(this).data("method")

      switch component
        when "view"

          switch method
            when "getViewByName"
            # reset the active nav links
              $("#globalNavigationDiv a").parent().removeClass('active')

              # display the new template
              controller.view = $(this).data("name")
              controller.displayView()

              if $("#carousel").is(":visible")
                $("#carousel").fadeOut('slow')

              if $(this).data("name") is "index"
                $("#carousel").fadeIn('slow')

              if $(this).data("name") is "about"
                $("#navAboutLink").parent().addClass('active')

              if $(this).data("name") is "knowledge"
                $("#navKnowledgeLink").parent().addClass('active')

    $("#globalNavigationDiv").on 'click', 'a', (e)->

      component = $(this).data("component")
      method    = $(this).data("method")

      switch component
        when "view"

          switch method
            when "getViewByName"
              # reset the active nav links
              $("a").parent().removeClass('active')
              $(this).parent().addClass('active')

              # display the new template
              controller.view = $(this).data("name")
              controller.displayView()

              if $("#carousel").is(":visible")
                $("#carousel").fadeOut('slow')

              if $(this).data("name") is "index"
                $("#carousel").fadeIn('slow')

              if $(this).data("name") is "ndoutils"
                getData = ()->
                  window.controller.getServiceDetailsByHost()

                setTimeout getData, 550

    return @

  computeNdoutilStats: (hosts)->
    totalHosts = 0
    badHosts   = 0

    totalServices = 0
    badServices   = 0

    for id of hosts
      totalHosts++
      if hosts[id].current_state > 0
        badHosts++

      if hosts[id].services.length > 0
        for sid of hosts[id].services
          totalServices++

          if hosts[id].services[sid].service_current_state > 0
            badServices++

    percentBadHosts  = (badHosts / totalHosts) * 100
    percentGoodHosts = 100 - percentBadHosts

    percentBadServices  = (badServices / totalServices) * 100
    percentGoodServices = 100 - percentBadServices

    totalOverall = totalHosts + totalServices
    badOverall   = badHosts + badServices

    percentBadOverall = (badOverall / totalOverall) * 100
    percentGoodOverall = 100 - percentBadOverall

    $("#hostsH2").html    "Host Status ( #{totalHosts - badHosts} / #{totalHosts} )"
    $("#servicesH2").html "Service Status ( #{totalServices - badServices} / #{totalServices} )"
    $("#overallH2").html  "Overall Status ( #{totalOverall - badOverall} / #{totalOverall} )"

    hostsPieChartData = [
      {
        value: Math.round(percentBadHosts),
        color: "red"
      },
      {
        value: Math.round(percentGoodHosts),
        color: "green"
      }
    ]

    servicesPieChartData = [
      {
        value: Math.round(percentBadServices),
        color: "red"
      },
      {
        value: Math.round(percentGoodServices),
        color: "green"
      }
    ]

    overallPieChartData = [
      {
        value: Math.round(percentBadOverall),
        color: "red"
      },
      {
        value: Math.round(percentGoodOverall),
        color: "green"
      }
    ]

    fn1 = ()->
      el = document.getElementById("hostsPieChart")
      $(el).removeClass('hide').hide().fadeIn('slow')
      hostsPieChartCanvas   = el.getContext("2d")
      hostsPieChartInstance = new Chart(hostsPieChartCanvas).Pie(hostsPieChartData)

    fn2 = ()->
      el = document.getElementById("servicesPieChart")
      $(el).removeClass('hide').hide().fadeIn('slow')
      servicesPieChartCanvas   = el.getContext("2d")
      servicesPieChartInstance = new Chart(servicesPieChartCanvas).Pie(servicesPieChartData)

    fn3 = ()->
      el = document.getElementById("overallPieChart")
      $(el).removeClass('hide').hide().fadeIn('slow')
      overallPieChartCanvas   = el.getContext("2d")
      overallPieChartInstance = new Chart(overallPieChartCanvas).Pie(overallPieChartData)

    setTimeout fn1, 150
    setTimeout fn2, 350
    setTimeout fn3, 550

window.Controller = Controller