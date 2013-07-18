class @EndlessScrolling
  @setup: ->
    if $('.pagination').length > 0
      $(window).scroll ->
        url = $('.pagination a[rel=next]').attr('href')
        if url && $(window).scrollTop() > $(document).height() - $(window).height() - 200
          $('.pagination').text(I18n.t('fetching_more_products'))
          $.getScript(url)
      $(window).scroll()