<?php
/**
 * Template Name: Home
 *
 * Template personalizado para la home de EHC.
 *
 * @package Trending
 * @subpackage Template
 */

get_header(); // Loads the header.php template. ?>

	<div id="columnaIzq">
			<div class="mensaje">
			<iframe width="505" height="265" src="//www.youtube.com/embed/C6lYpQVPOCQ?rel=0" frameborder="0" allowfullscreen></iframe>
			</div>	
	</div><!-- #columnaIzq -->

	<div id="columnaDer">
		
		<div class="hfeed">

			<?php if ( have_posts() ) : ?>

				<?php query_posts('ignore_sticky_posts=1&cat=-10,-7&showposts=3&orderby=date'); ?>

					<?php while ( have_posts() ) : the_post(); ?>
					<div id="post-<?php the_ID(); ?>" class="<?php hybrid_entry_class(); ?>">
				
						<?php if ( current_theme_supports( 'get-the-image' ) )
							get_the_image( array( 'meta_key' => 'Thumbnail', 'size' => 'thumbnail' ));
						?>
						<!--<?php echo get_the_post_thumbnail( $post->ID, 'thumbnail' ); ?> -->

						<?php echo apply_atomic_shortcode( 'entry_title', '[entry-title-short permalink="1" excerpt="30"]' ); ?>
						

						<div class="entry-content">
							<?php estractoPortada('120'); ?>
							<!--<?php wp_link_pages( array( 'before' => '<p class="page-links">' . __( 'Pages:', 'trending' ), 'after' => '</p>' ) ); ?>-->
						</div><!-- .entry-content -->

						<!--<?php echo apply_atomic_shortcode( 'entry_meta', '<div class="entry-meta">[entry-edit-link]</div>' ); ?>-->

					</div><!-- .hentry -->

				<?php endwhile; ?>
			<?php //wp_reset_query(); ?> 
			<?php endif; ?>
		<div class="more"><a href="http://centrodedanzayartedemadrid.com/web/noticias">Leer mas noticias</a></div>
		</div><!-- .hfeed -->

		<?php wp_reset_query(); ?>
	
	</div><!-- columnaDer -->

				<?php do_atomic( 'close_main' ); // trending_close_main ?>

	</div><!-- .wrap -->

	</div><!-- #main -->

		<?php do_atomic( 'after_main' ); // trending_after_main ?>



		<?php do_atomic( 'before_footer' ); // trending_before_footer ?>

		<div id="columnaMedia">

			<div class="izq">
				<div id="instalaciones_logo"><a title="Control Outdoor" href="http://ehcontrol.net"><img title="Control Outdoor" src="http://ehcontrol.net/web/wp-content/themes/ehc/images/indoor.jpg" alt="" width="120" height="100" /></a></div>
				
			<div id="titulo"><a title="Control Outdoor" href="http://ehcontrol.net">Control Outdoor</a></div>
			</div>

			<div class="centIzq">
				<div id="fotos_logo"><a title="Control Indoor" href="http://ehcontrol.net"><img title="Ver Fotos" src="http://ehcontrol.net/web/wp-content/themes/ehc/images/outdoor.jpg" alt="" width="120" height="100" /></a></div>
				<div id="titulo"><a title="Control Indoor" href="http://ehcontrol.net">Control Indoor</a></div>
			</div>

			<div class="centDer">
				<div id="videos_logo"><a title="Control Móvil" href="http://ehcontrol.net"><img title="Ver Videos" src="http://ehcontrol.net/web/wp-content/themes/ehc/images/movil.jpg" alt="" width="120" height="100" /></a></div>
				<div id="titulo"><a title="Control Móvil" href="http://ehcontrol.net">App Móvil</a></div>
			</div>

		</div>

		<div id="columnaLogos">
						<div class="titulos">
				
			</div>	
		</div>

		<div id="columnaRedes">
<iframe src="//www.facebook.com/plugins/likebox.php?href=https%3A%2F%2Fwww.facebook.com%2Fehcontrol&amp;width=550&amp;height=290&amp;colorscheme=light&amp;show_faces=true&amp;header=true&amp;stream=false&amp;show_border=true" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:520px; height:290px;" allowTransparency="true"></iframe>
		</div>

		<div id="columnaMapa">
		</div>

		<div id="footer">

			<?php do_atomic( 'open_footer' ); // trending_open_footer ?>

			<div class="wrap">

				<div class="footer-content">
					<?php hybrid_footer_content(); ?>
					<?php informacion(); ?>
				</div><!-- .footer-content -->

				<?php do_atomic( 'footer' ); // trending_footer ?>

			</div><!-- .wrap -->

			<?php do_atomic( 'close_footer' ); // trending_close_footer ?>

		</div><!-- #footer -->

		<?php do_atomic( 'after_footer' ); // trending_after_footer ?>

	</div><!-- #container -->

	<?php do_atomic( 'close_body' ); // trending_close_body ?>

	<?php wp_footer(); // wp_footer ?>

</body>
</html>
