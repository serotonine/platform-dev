<?php

/**
 * @file
 * Contains the template file of the banner component.
 *
 * Available variables:
 * - $quote: string or a render array.
 * - $author: string or a render array.
 */
?>
<div class="ecl-banner ecl-banner--hero">
  <?php print $image; ?>
  <div class="ecl-banner__content">
    <h3 class="ecl-heading ecl-heading--h3 ecl-banner__title">
      <?php print $link; ?>
    </h3>
    <p class="ecl-paragraph ecl-banner__description"><?php print $description; ?></p>
  </div>
</div>
