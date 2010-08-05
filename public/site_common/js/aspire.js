	$(window).load(function() {
		
		
		//Slider Settings - Read more here: http://nivo.dev7studios.com/ //
		$('#slider').nivoSlider({
			directionNav:true,
			controlNav:true,
			effect:'random',
			slices:15,
			animSpeed:450,
			pauseTime:2500,			
			pauseOnHover:true, //Stop animation while hovering
			captionOpacity:0.8, //Universal caption opacity
		});
		
		
		$('ul.social li a').tipsy({gravity: 'n'});
		
		$('ul.sf-menu').superfish();
		
		Cufon.replace('ul.sf-menu:has(ul) > li a, ul.quick_links li h3, #page h2, #page h3, #page h4, #page h5, #sidebar h2, .sub_header p, .article_nav a', { fontFamily: 'Avenir LT Std' });
		
		$('form.search input').focus(function() {
  			$(this).val('');
		});
		
		$("#gallery li").append("<span></span>");
		
		$('#gallery li').each(function() {
            $(this).hover(function() {
                $(this).children("a").children("img").stop().animate({ opacity: 0.5 }, 500);
                $(this).children("span").fadeIn(600);
            },
           function() {
               $(this).children("a").children("img").stop().animate({ opacity: 1 }, 500);
               $(this).children("span").fadeOut(200); 
           });
        });
        
        $("a[rel^='prettyPhoto']").prettyPhoto();
		

	});
	