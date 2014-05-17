<?php
/* Función para conocer si una página es subpagina de otra */

function is_subpage() {
	global $post;                              // load details about this page
		if ( is_page() && $post->post_parent ) {   // test to see if the page has a parent
	        return $post->post_parent;             // return the ID of the parent post
		} 
		else {                                   // there is no parent so ...	
        	return false;                          // ... the answer to the question is false
		}
}

/* Eliminar la opción de modificar el fondo y el footer */
	function eliminaSoporteTema() {
	remove_theme_support('custom-background');
	remove_theme_support('hybrid-core-theme-settings');
	add_theme_support( 'hybrid-core-theme-settings', array( 'about' , 'footer') );
	}

	add_action( 'after_setup_theme', 'eliminaSoporteTema', 11 ); // Usa 11 para cargar después del tema 'padre'

/* Modifica la longitud del estracto para mostrar las noticias en la portada */
	function estractoPortada($num) {
	$permalink = get_permalink($post->ID);
	$excerpt = get_the_content();
	$excerpt = strip_tags($excerpt);
	$excerpt = substr($excerpt, 0, $num);
	$excerpt = $excerpt.'...';
	echo $excerpt;
	}

/* Modifica los caracteres que se muestran al cortar un estracto de texto */
	function modificaCorteEstracto( $more ) {
		return '...';
	}
	add_filter('excerpt_more','modificaCorteEstracto');

/* Modifica la longitud del título para mostrar las noticias en portada
** Añade un nuevo tipo shortcode con dos parametros: permalink y excerpt. */
	function hybrid_entry_title_excerpt_shortcode( $attr ) {

	$attr = shortcode_atts( array( 'permalink' => true, 'excerpt' => 10), $attr );

	$tag = is_singular() ? 'h1' : 'h2';
	$class = sanitize_html_class( get_post_type() ) . '-title entry-title';
	$mytitle = get_the_title();

	if ( false == (bool)$attr['permalink'] ){
			if ( strlen($mytitle) > $attr['excerpt'] ){
				$mytitle = substr($mytitle,0,$attr['excerpt']);
				$title = "<{$tag} class={$class}'>" . $mytitle . " ...</{$tag}>";
			}
			else $title = "<{$tag} class='{$class}'>".$mytitle."</{$tag}>";
	}
	else{
		if ( strlen($mytitle) > $attr['excerpt'] ){
		$mytitle = substr($mytitle,0,$attr['excerpt']);
		$title = "<{$tag} class='{$class}'><a href='" . get_permalink() . "'>" . $mytitle . " ...</a></{$tag}>";
		}
		else $title = "<{$tag} class='{$class}'><a href='" . get_permalink() . "'>".$mytitle."</a></{$tag}>";
	}
	
	if ( empty( $title ) && !is_singular() )
	$title = "<{$tag} class='{$class}'><a href='" . get_permalink() . "'>" . __( '(Untitled)', 'hybrid-core' ) . "</a></{$tag}>";

	return $title;
	}

	add_action( 'after_setup_theme', 'addShortCode', 11 );

	function addShortCode() {
		add_shortcode( 'entry-title-short', 'hybrid_entry_title_excerpt_shortcode' );
	}
/* Modifica el logo por defecto del panel de administración */
	function my_login_logo() { ?>
    	<style type="text/css">
        	body.login div#login h1 a {
       	     background-image: url(<?php echo get_bloginfo( 'stylesheet_directory' ) ?>/images/logo.png);
       	     padding-bottom: 30px;
      	  }
   	 </style>
	<?php }
	add_action( 'login_enqueue_scripts', 'my_login_logo' );

/* Modifica la dirección del logo del panel de administración */
	function my_login_logo_url() {
	return get_bloginfo( 'url' );
	}
	add_filter( 'login_headerurl', 'my_login_logo_url' );

/* Modifica la descripción del enlace del panel de administración */
	function my_login_logo_url_title() {
    	return 'EHC - EveryWhere House Control';
	}
	add_filter( 'login_headertitle', 'my_login_logo_url_title' );

/* Modifica el pie de página del panel de administración */
	function change_footer_admin() {  
	echo '&copy;2014 Copyright EHC. Todos los derechos reservados';  
	}
	add_filter('admin_footer_text', 'change_footer_admin');

	add_action( 'admin_menu', 'adjust_the_wp_menu', 999 );
	function adjust_the_wp_menu() {
	  $page = remove_submenu_page( 'themes.php', 'customize.php' );
	  // $page[0] is the menu title
	  // $page[1] is the minimum level or capability required
	  // $page[2] is the URL to the item's file
	}

	add_action( 'admin_print_styles', 'load_custom_admin_css' );
	function load_custom_admin_css(){
		wp_enqueue_style('my_style', WP_CONTENT_URL . '/themes/custom_admin.css');
	}
?>
