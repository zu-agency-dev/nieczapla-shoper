    {assign var="columnCounter" value=3}
    {if 0 < (int) $layout->layout->left_col_width}
      {assign var="columnCounter" value=$columnCounter-1}
    {/if}
    {if 0 < (int) $layout->layout->right_col_width}
      {assign var="columnCounter" value=$columnCounter-1}
    {/if}

    <div class="categories__wrapper">
      {if count($headerlinks)}
        {foreach from=$headerlinks item=link}
          {if $link->getHref() || $link->isActiveCategory()}
            <a {if $link->isCategory()}id="hcategory_{$link->getCategoryId()|escape}" {/if}
              {if $link->isPopup()}target="_blank" rel="noopener" {/if} href="{$link->getHref($view)|escape}"
              title="{$link->getTitle()|escape}" id="headlink{$link->getIdentifier()}" class="categories__item">
              <span class="categories__item--title">{$link->getTitle()|escape}</span>
                <span class="categories__item--description">
                  {if $link->getCategoryId() == 38}Przelew | Aeropress | Frenchpress{/if}
                  {if $link->getCategoryId() == 39}Kolba | Automat | Kawiarka{/if}
                  {if $link->getCategoryId() == 40}Filtry | Merch | Inne{/if}
                </span>
            </a>
          {/if}
        {/foreach}
      {/if}
    </div>

    {if 'full' == $view || $view == 'desc'}
      <div class="products view{$view}" {if $price_mode == '2'}data-netto="true" {/if}>
        {foreach from=$products item=product name=prodlist}
          <div data-product-id="{$product->product->product_id}"
            data-category="{$product->defaultCategory->translation->name|escape}"
            {if $product->product->producer_id}data-producer="{$product->producer->manufacturer->name|escape}" {/if}
            class="oneperrow f-row product product_view-extended {$columnCounter}{if $product->readVisibilityConfigFlag($listItemGrayFlag)} product_inactive{/if}">
            <div class="f-row description">
              <h3 class="small tablet f-grid-12">
                <a href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                  title="{$product->translation->name|escape}" rel="nofollow">
                  {$product->translation->name|escape}
                </a>
              </h3>

              <div>
                <a class="details f-grid-4 prodimage"
                  href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                  title="{$product->translation->name|escape}" rel="dofollow">
                  <span class="f-grid-12 img-wrap lazy-load">
                    <img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D"
                      width="{imageWidth gfx=$product->getPromotingGfx() thumbnailSize=$skin_settings->img->medium}"
                      height="{imageHeight gfx=$product->getPromotingGfx() thumbnailSize=$skin_settings->img->medium}"
                      data-src="{imageUrl type='productGfx' width=$skin_settings->img->medium height=$skin_settings->img->medium image=$product->getPromotingGfxName() overlay=1}"
                      alt="{$product->translation->name|escape}">

                    <noscript>
                      <img
                        src="{imageUrl type='productGfx' width=$skin_settings->img->medium height=$skin_settings->img->medium image=$product->getPromotingGfxName() overlay=1}"
                        width="{imageWidth gfx=$product->getPromotingGfx() thumbnailSize=$skin_settings->img->medium}"
                        height="{imageHeight gfx=$product->getPromotingGfx() thumbnailSize=$skin_settings->img->medium}"
                        alt="{$product->translation->name|escape}">
                    </noscript>
                  </span>
                </a>

                <div class="f-grid-8">
                  <a class="f-grid-12 prodname large"
                    href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                    title="{$product->translation->name|escape}">
                    <span class="productname">{$product->translation->name|escape}</span>
                  </a>

                  <div class="js__prodcut-short-desc product-short-description resetcss large">
                    {$product->translation->short_description}
                  </div>

                  {if ($product->defaultStock && $product->canBuyStock() && 1 == (int) $skin_settings->$settingsgroup->showdelivery) || ($product->defaultStock && 1 == (int) $skin_settings->$settingsgroup->showavailability)}
                    <p class="avail">
                      {if 1 == (int) $skin_settings->$settingsgroup->showavailability && $product->defaultStock->availability && $product->defaultStock->availability->translation}
                        <span class="availability">{translate key="Availability"}:</span>
                        <span class="availability">{if $product->defaultStock->availability->availability->photo}
                            <img src="{baseDir}/{$product->defaultStock->availability->getUrl()}" alt="" />
                          {/if}{$product->defaultStock->availability->translation->name}</span>
                      {/if}
                      {if 1 == (int) $skin_settings->$settingsgroup->showdelivery && $product->canBuyStock() && $product->defaultStock->delivery}
                      </p>
                      <p class="deliv">
                        <span class="delivery">{translate key="Dispatched within"}:</span>
                        <span class="delivery">{$product->defaultStock->delivery->translation->name|escape}</span>
                      {/if}
                    </p>
                  {/if}

                  {if ($enable_availability_notifier && $product->isEnabledNotifier()) || ($enablebasket && $product->canBuyStock())}
                    {if true == $product->defaultStockOnly()}
                      <form class="basket f-grid-12 right {if $loyalty_exchange}loyaltyexchange{/if}"
                        action="{route key=$basketAddRoute stockId='post'}" method="post">
                      {else}
                        <form class="basket f-grid-12 right {if $loyalty_exchange}loyaltyexchange{/if}"
                          action="{route key=$basketAddRoute stockId=$product->defaultStock->getIdentifier()}" method="get">
                        {/if}
                      {/if}

                      {if $loyalty_exchange}
                        <div
                          class="price{if ($enable_availability_notifier && $product->isEnabledNotifier()) == false && ($enablebasket && $product->canBuyStock()) == false} noform{/if}">
                          <span>{translate key="Price"}:</span>
                          <em>
                            {float precision=0 value=$product->defaultStock->loyaltyPointsPrice(true)}

                            {if $product->defaultStock->loyaltyCurrencyPrice() != 0}
                              + {currency value=$product->defaultStock->loyaltyCurrencyPrice()}
                            {/if}
                          </em>
                        </div>
                      {else}
                        {if $showprices}
                          <div
                            class="price{if ($enable_availability_notifier && $product->isEnabledNotifier()) == false && ($enablebasket && $product->canBuyStock()) == false} noform{/if}">
                            {if $price_mode == '1' || $price_mode == '3'}
                              <span>{translate key="Price"}:</span>
                              {if $product->specialOffer}
                                <p>
                                  <em>{currency value=$product->defaultStock->getSpecialOfferPrice()}</em>
                                </p>

                                <div class="price__additional-info">
                                  {if $additional_tax_info == '1'}
                                    {assign var=productTax value=$product->getTax()}
                                    <div class="tax-additional-info">
                                      {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                        {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                      {elseif $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                        {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                      {else}
                                        {translate key="excl. shipping costs"}
                                      {/if}
                                    </div>
                                  {/if}

                                  {if $product->product->unit_price_calculation && $unit_price_calculation}
                                    {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                    <div class="unit-price-container">
                                      {if $price_mode == '1' || $price_mode == '3'}
                                        <i class="default-currency">
                                          ( 1 {$unit->translation->name} =
                                          {if $product->specialOffer}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                          {else}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                          {/if}
                                          )
                                        </i>
                                      {elseif $price_mode == '2'}
                                        <i class="default-currency">
                                          ( 1 {$unit->translation->name} =
                                          {if $product->specialOffer}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                          {else}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                          {/if}
                                          )
                                        </i>
                                      {/if}
                                    </div>
                                  {/if}
                                </div>

                                {if $isRegularPriceVisible}
                                  <p class="price__regular">
                                    {translate key="Regular price"}:
                                    <del class="price__inactive">{currency value=$product->defaultStock->getPrice()}</del>
                                  </p>
                                {/if}

                                {if $showLowestPriceHistory && $isLowestPriceVisible}
                                  <div class="f-row clear price__omnibus">
                                    {translate key='Lowest price'}:
                                    <strong class="js__omnibus-price-gross price__inactive">
                                      {currency value=$product->stock->getHistoricalLowestPrice()}
                                    </strong>
                                  </div>
                                {/if}

                                {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                  <p class="product__currency price__currency">
                                    {translate key="Price"} ({$product->currency->currency->name|escape}):
                                    <em
                                      class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice()}</em>
                                  </p>
                                {/if}
                              {else}
                                <p>
                                  <em>{currency value=$product->defaultStock->getPrice()}</em>
                                </p>

                                <div class="price__additional-info">
                                  {if $additional_tax_info == '1'}
                                    {assign var=productTax value=$product->getTax()}
                                    <div class="tax-additional-info">
                                      {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                        {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                      {else}
                                        {translate key="excl. shipping costs"}
                                      {/if}
                                    </div>
                                  {/if}

                                  {if $product->product->unit_price_calculation && $unit_price_calculation}
                                    {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                    <div class="unit-price-container">
                                      {if $price_mode == '1' || $price_mode == '3'}
                                        <i class="default-currency">
                                          ( 1 {$unit->translation->name} =
                                          {if $product->specialOffer}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                          {else}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                          {/if}
                                          )
                                        </i>
                                      {/if}
                                    </div>
                                  {/if}
                                </div>

                                {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                  <p class="product__currency price__currency">
                                    {translate key="Price"} ({$product->currency->currency->name|escape}):
                                    <em
                                      class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice()}</em>
                                  </p>
                                {/if}
                              {/if}
                            {/if}

                            {if $price_mode == '1' || $price_mode == '2'}
                              {if $price_mode == '1'}
                                <i class="price-netto">
                                {/if}
                                {if $product->specialOffer}
                                  <p>
                                    {if $price_mode == '1'}
                                      {translate key="Net price"}:
                                    {/if}
                                    <em>{currency value=$product->defaultStock->getSpecialOfferPrice(true)}</em>
                                  </p>

                                  <div class="price__additional-info">

                                    {if $additional_tax_info == '2' && $price_mode == '2'}
                                      {assign var=productTax value=$product->getTax()}
                                      <div class="tax-additional-info">
                                        {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                          {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                        {else}
                                          {translate key="excl. shipping costs"}
                                        {/if}
                                      </div>
                                    {/if}

                                    {if $product->product->unit_price_calculation && $unit_price_calculation}
                                      {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                      <div class="unit-price-container">
                                        {if $price_mode == '2'}
                                          <i class="default-currency">
                                            ( 1 {$unit->translation->name} =
                                            {if $product->specialOffer}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                            {else}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                            {/if}
                                            )
                                          </i>
                                        {/if}
                                      </div>
                                    {/if}
                                  </div>

                                  {if $price_mode == '2'}
                                    {if $isRegularPriceVisible}
                                      <p class="price__regular">
                                        {translate key="Regular price"}:
                                        <del class="price__inactive">{currency value=$product->defaultStock->getPrice(true)}</del>
                                      </p>
                                    {/if}

                                    {if $showLowestPriceHistory && $isLowestPriceVisible}
                                      <div class="f-row clear price__omnibus">
                                        {translate key='Lowest price'}:
                                        <strong class="js__omnibus-price-gross price__inactive">
                                          {currency value=$product->stock->getHistoricalLowestPrice(true)}
                                        </strong>
                                      </div>
                                    {/if}

                                    {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                      <p class="product__currency price__currency">
                                        {translate key="Price"} ({$product->currency->currency->name|escape}):
                                        <em
                                          class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice(true)}</em>
                                      </p>
                                    {/if}
                                  {/if}
                                {else}
                                  <p>
                                    {if $price_mode == '1'}
                                      {translate key="Net price"}:
                                    {/if}
                                    <em>{currency value=$product->defaultStock->getPrice(true)}</em>
                                  </p>

                                  {if $price_mode == '2'}
                                    <div class="price__additional-info">
                                      {if $additional_tax_info == '1'}
                                        {assign var=productTax value=$product->getTax()}
                                        <div class="tax-additional-info">
                                          {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                            {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                          {else}
                                            {translate key="excl. shipping costs"}
                                          {/if}
                                        </div>
                                      {/if}

                                      {if $product->product->unit_price_calculation && $unit_price_calculation}
                                        {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                        <div class="unit-price-container">
                                          {if $price_mode == '2'}
                                            <i class="default-currency">
                                              ( 1 {$unit->translation->name} =
                                              {if $product->specialOffer}
                                                {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                              {else}
                                                {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                              {/if}
                                              )
                                            </i>
                                          {/if}
                                        </div>
                                      {/if}
                                    </div>

                                    {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                      <p class="product__currency price__currency">
                                        {translate key="Price"} ({$product->currency->currency->name|escape}):
                                        <em
                                          class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice(true)}</em>
                                      </p>
                                    {/if}
                                  {/if}
                                {/if}
                                {if $price_mode == '1'}
                                </i>
                              {/if}
                            {/if}
                          </div>
                        {/if}
                      {/if}

                      {if ($enable_availability_notifier && $product->isEnabledNotifier()) || ($enablebasket && $product->canBuyStock())}
                        {if $enablebasket && $product->canBuyStock()}
                          <fieldset>
                            {if true == $product->defaultStockOnly()}
                              <div class="shaded_inputwrap"><input name="quantity"
                                  value="{float precision=$QUANTITY_PRECISION value=1 trim=true}" type="text"
                                  class="short center"></div>
                              <span class="unit">{$product->unit->translation->name|escape}</span>
                              <input type="hidden" value="{$product->defaultStock->getIdentifier()|escape}" name="stock_id">

                              {foreach from=$product->getOptionsConfigurationStruct() item=option}
                                {if $option.required}
                                  <input type="hidden" name="required" value="1">
                                  {break}
                                {/if}
                              {/foreach}
                            {/if}

                            {if $product->isBundle()}
                              {assign var=bundleHasVariants value=false}
                              {capture assign=bundle}
                                {strip}
                                  [
                                  {foreach from=$product->bundle->stocks item=bundleStock name=bundleList key=k}
                                    {assign var=bundleChildren value=$product->bundle->getLogicStockById($bundleStock->getIdentifier())}
                                    {assign var=bundleOptions value=$bundleChildren->product->getOptionsConfigurationStruct()}

                                    {if $bundleChildren->product->product->group_id && count($bundleOptions)}
                                      {assign var=bundleHasVariants value=true}
                                      {break}
                                    {/if}

                                    {if !$smarty.foreach.bundleList.last}
                                      {literal}{{/literal}
                                      "id":{$bundleStock->getIdentifier()},
                                      "stock_id":{$bundleChildren->getIdentifier()},
                                      "stockId":{$bundleChildren->getIdentifier()},
                                      "quantity":{$bundleStock->stock->stock|escape}
                                      {literal}}{/literal},
                                    {else}
                                      {literal}{{/literal}
                                      "id":{$bundleStock->getIdentifier()},
                                      "stock_id":{$bundleChildren->getIdentifier()},
                                      "stockId":{$bundleChildren->getIdentifier()},
                                      "quantity":{$bundleStock->stock->stock|escape}
                                      {literal}}{/literal}
                                    {/if}
                                  {/foreach}
                                  ]
                                {/strip}
                              {/capture}

                              {if !$bundleHasVariants}
                                <input type="hidden" value="{$bundle|base64_encode}" name="children">
                              {/if}
                            {/if}

                            {if !$product->isBundle() || !$bundleHasVariants}
                              <button class="addtobasket btn btn-red" type="submit">
                                <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                                <span>{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</span>
                              </button>
                            {else}
                              <a href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                                class="btn btn-red">{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</a>
                            {/if}
                          </fieldset>
                        {elseif $enable_availability_notifier && $product->isEnabledNotifier()}
                          {dynamic}
                          {assign var="availabilityNotifyUser" value=$product->defaultStock->getAvailabilityNotifyByUser()}
                          <fieldset class="availability-notifier-container{if $availabilityNotifyUser != null} none{/if}">
                            <button class="availability-notifier-btn btn btn-red" type="submit"
                              data-is-logged="{if true == $user_logged}true{else}false{/if}"
                              data-stock-id="{$product->defaultStock->getIdentifier()}"
                              data-product-id="{$product->product->product_id}"
                              data-product-name="{$product->translation->name|escape}">
                              <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                              <span>{translate key="Notify of product availability"}</span>
                            </button>
                          </fieldset>
                          {if true == $user_logged}
                            <fieldset
                              class="availability-notifier-unsubscribe-container{if $availabilityNotifyUser == null} none{/if}">
                              <button type="submit" class="availability-notifier-unsubscribe-btn btn btn-red"
                                data-stock-id="{$product->defaultStock->stock->stock_id}">
                                <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                <span>{translate key="Cancel notify"}</span>
                              </button>
                            </fieldset>
                          {/if}
                          {/dynamic}
                        {/if}
                      {/if}

                      {if ($enable_availability_notifier && $product->isEnabledNotifier()) || ($enablebasket && $product->canBuyStock())}
                      </form>
                    {/if}
                </div>
              </div>
            </div>

            {if $product->specialOffer || $product->isNew()}
              <ul class="tags">
                {if $product->specialOffer}
                  <li class="promo">
                    <span>{translate key="on sale tag"}</span>
                  </li>
                {/if}
                {if $product->isNew()}
                  <li class="new">
                    <span>{translate key="new product tag"}</span>
                  </li>
                {/if}
              </ul>
            {/if}
          </div>
        {/foreach}
      </div>
    {elseif 'phot' == $view}
      <div class="products view{$view} zu-grid zu-grid-gap-2" {if $price_mode == '2'}data-netto="true" {/if}>
        {foreach from=$products item=product name=prodlist}
          <div data-product-id="{$product->product->product_id}"
            data-category="{$product->defaultCategory->translation->name|escape}"
            {if $product->product->producer_id}data-producer="{$product->producer->manufacturer->name|escape}" {/if}
            class="product product_view-extended product-main-wrap{if $additional_tax_info == '1'} additional-info{/if}{if $unit_price_calculation} unit-price-info{/if}{if $product->readVisibilityConfigFlag($listItemGrayFlag)} product_inactive{/if}{if $showLowestPriceHistory && $isLowestPriceVisible} product_with-lowest-price{/if}{if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()} product_with-currency{/if}">
            <div class="product-inner-wrap">
              <a class="prodimage f-row" href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name
                            productId=$product->product->product_id}" title="{$product->translation->name|escape}"
                rel="dofollow">
                <span class="f-grid-12 img-wrap{if $product->galleryGfxs|@count > 1} replace-img-list{/if} lazy-load">
                  <img src="data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs%3D"
                    data-src="{imageUrl type='productGfx' width=$skin_settings->img->medium height=$skin_settings->img->medium image=$product->getPromotingGfxName() overlay=1}"
                    alt="{$product->translation->name|escape}" {foreach from=$product->galleryGfxs item=img name=gal}
                      {if $smarty.foreach.gal.index == 1}
                        data-src-alt="{imageUrl type='productGfx' width=$skin_settings->img->medium height=$skin_settings->img->medium image=$img->gfx->unic_name}"
                      {/if} 
                    {/foreach} />

                  <div class="img-overlay">
                    <div class="overlay-notes">
                      <p>{if $product->defaultCategory->translation->name == 'Akcesoria'}Producent:{else} {/if}</p>
                      <p>{$product->attributes[2].value|escape}</p>
                    </div>
                    <!-- <div class="overlay-variation">
                      <p>{if $product->defaultCategory->translation->name == 'Akcesoria'}Ilość sztuk w opakowaniu:{else}Odmiana:{/if}</p>
                      <p>{$product->attributes[3].value|escape}</p>
                    </div>
                    <div class="overlay-treatment">
                      <p>{if $product->defaultCategory->translation->name == 'Akcesoria'}Waga produktu:{else}Obróbka:{/if}</p>
                      <p>{$product->attributes[4].value|escape}</p>
                    </div> -->
                  <div class="product__basket">
                    <div class="price f-row">
                      {if $loyalty_exchange}
                        <span>{translate key="Price"}:</span>
                        <em>
                          {float precision=0 value=$product->defaultStock->loyaltyPointsPrice(true)}

                          {if $product->defaultStock->loyaltyCurrencyPrice() != 0}
                            + {currency value=$product->defaultStock->loyaltyCurrencyPrice()}
                          {/if}
                        </em>
                      {else}
                        {if $showprices}
                          {if $price_mode == '1' || $price_mode == '3'}
                            <span>{translate key="Price"}:</span>
                            {if $product->specialOffer}
                              <p>
                                <em>{currency value=$product->defaultStock->getSpecialOfferPrice()}</em>
                              </p>

                              <div class="price__additional-info">
                                {if $additional_tax_info == '1'}
                                  {assign var=productTax value=$product->getTax()}
                                  <div class="tax-additional-info">
                                    {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {elseif $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {else}
                                      {translate key="excl. shipping costs"}
                                    {/if}
                                  </div>
                                {/if}

                                {if $product->product->unit_price_calculation && $unit_price_calculation}
                                  {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                  <div class="unit-price-container">
                                    {if $price_mode == '1' || $price_mode == '3'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                        {/if}
                                        )
                                      </i>
                                    {elseif $price_mode == '2'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                        {/if}
                                        )
                                      </i>
                                    {/if}
                                  </div>
                                {/if}
                              </div>

                              {if $isRegularPriceVisible}
                                <p class="price__regular">
                                  {* {translate key="Regular price"}: *}
                                  <del class="price__inactive">{currency value=$product->defaultStock->getPrice()}</del>
                                </p>
                              {/if}

                              {if $showLowestPriceHistory && $isLowestPriceVisible}
                                <div class="f-row clear price__omnibus">
                                  {translate key='Lowest price'}:
                                  <strong class="js__omnibus-price-gross price__inactive">
                                    {currency value=$product->stock->getHistoricalLowestPrice()}
                                  </strong>
                                </div>
                              {/if}

                              {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                <p class="product__currency price__currency">
                                  {translate key="Price"} ({$product->currency->currency->name|escape}):
                                  <em
                                    class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice()}</em>
                                </p>
                              {/if}
                            {else}
                              <p>
                                <em>{currency value=$product->defaultStock->getPrice()}</em>
                              </p>

                              <div class="price__additional-info">
                                {if $additional_tax_info == '1'}
                                  {assign var=productTax value=$product->getTax()}
                                  <div class="tax-additional-info">
                                    {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {else}
                                      {translate key="excl. shipping costs"}
                                    {/if}
                                  </div>
                                {/if}

                                {if $product->product->unit_price_calculation && $unit_price_calculation}
                                  {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                  <div class="unit-price-container">
                                    {if $price_mode == '1' || $price_mode == '3'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                        {/if}
                                        )
                                      </i>
                                    {/if}
                                  </div>
                                {/if}
                              </div>

                              {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                <p class="product__currency price__currency">
                                  {translate key="Price"} ({$product->currency->currency->name|escape}):
                                  <em
                                    class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice()}</em>
                                </p>
                              {/if}
                            {/if}
                          {/if}

                          {if $price_mode == '1' || $price_mode == '2'}
                            {if $price_mode == '1'}
                              <i class="price-netto">
                              {/if}
                              {if $product->specialOffer}
                                <p>
                                  {if $price_mode == '1'}
                                    {translate key="Net price"}:
                                  {/if}
                                  <em>{currency value=$product->defaultStock->getSpecialOfferPrice(true)}</em>
                                </p>

                                <div class="price__additional-info">

                                  {if $additional_tax_info == '2' && $price_mode == '2'}
                                    {assign var=productTax value=$product->getTax()}
                                    <div class="tax-additional-info">
                                      {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                        {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                      {else}
                                        {translate key="excl. shipping costs"}
                                      {/if}
                                    </div>
                                  {/if}

                                  {if $product->product->unit_price_calculation && $unit_price_calculation}
                                    {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                    <div class="unit-price-container">
                                      {if $price_mode == '2'}
                                        <i class="default-currency">
                                          ( 1 {$unit->translation->name} =
                                          {if $product->specialOffer}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                          {else}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                          {/if}
                                          )
                                        </i>
                                      {/if}
                                    </div>
                                  {/if}
                                </div>

                                {if $price_mode == '2'}
                                  {if $isRegularPriceVisible}
                                    <p class="price__regular">
                                      {translate key="Regular price"}:
                                      <del class="price__inactive">{currency value=$product->defaultStock->getPrice(true)}</del>
                                    </p>
                                  {/if}

                                  {if $showLowestPriceHistory && $isLowestPriceVisible}
                                    <div class="f-row clear price__omnibus">
                                      {translate key='Lowest price'}:
                                      <strong class="js__omnibus-price-gross price__inactive">
                                        {currency value=$product->stock->getHistoricalLowestPrice(true)}
                                      </strong>
                                    </div>
                                  {/if}

                                  {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                    <p class="product__currency price__currency">
                                      {translate key="Price"} ({$product->currency->currency->name|escape}):
                                      <em
                                        class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice(true)}</em>
                                    </p>
                                  {/if}
                                {/if}
                              {else}
                                <p>
                                  {if $price_mode == '1'}
                                    {translate key="Net price"}:
                                  {/if}
                                  <em>{currency value=$product->defaultStock->getPrice(true)}</em>
                                </p>

                                {if $price_mode == '2'}
                                  <div class="price__additional-info">
                                    {if $additional_tax_info == '1'}
                                      {assign var=productTax value=$product->getTax()}
                                      <div class="tax-additional-info">
                                        {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                          {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                        {else}
                                          {translate key="excl. shipping costs"}
                                        {/if}
                                      </div>
                                    {/if}

                                    {if $product->product->unit_price_calculation && $unit_price_calculation}
                                      {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                      <div class="unit-price-container">
                                        {if $price_mode == '2'}
                                          <i class="default-currency">
                                            ( 1 {$unit->translation->name} =
                                            {if $product->specialOffer}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                            {else}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                            {/if}
                                            )
                                          </i>
                                        {/if}
                                      </div>
                                    {/if}
                                  </div>

                                  {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                    <p class="product__currency price__currency">
                                      {translate key="Price"} ({$product->currency->currency->name|escape}):
                                      <em
                                        class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice(true)}</em>
                                    </p>
                                  {/if}
                                {/if}
                              {/if}
                              {if $price_mode == '1'}
                              </i>
                            {/if}
                          {/if}
                        {/if}
                      {/if}
                    </div>
                  </div>
                  <div class="button-wrap">
                    {if !$product->isBundle() || !$bundleHasVariants}
                      <button class="addtobasket btn btn-red" type="submit">
                        <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                        <span>{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</span>
                      </button>
                    {else}
                      <a href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                        class="btn btn-red">{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</a>
                    {/if}
                  </div>
                  </div>

                  <noscript>
                    <img src="{imageUrl type='productGfx' width=$skin_settings->img->medium height=$skin_settings->img->medium
                                    image=$product->getPromotingGfxName() overlay=1}"
                      alt="{$product->translation->name|escape}" />
                  </noscript>
                </span>
              </a>
              <div class="product__details--wrapper">
                <div class="product__details--text-wrapper">
                  <div class="prodname prodname-center f-row">
                    <a href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                      class="productname"
                      title="{$product->translation->name|escape}">{$product->translation->name|escape}</a>
                    <!-- <p class="productdetails--p">
                      {$product->attributes[0].value|escape}/{$product->attributes[1].value|escape}</p> -->
                  </div>
                  <!-- <div class="product__basket">
                    <div class="price f-row">
                      {if $loyalty_exchange}
                        <span>{translate key="Price"}:</span>
                        <em>
                          {float precision=0 value=$product->defaultStock->loyaltyPointsPrice(true)}

                          {if $product->defaultStock->loyaltyCurrencyPrice() != 0}
                            + {currency value=$product->defaultStock->loyaltyCurrencyPrice()}
                          {/if}
                        </em>
                      {else}
                        {if $showprices}
                          {if $price_mode == '1' || $price_mode == '3'}
                            <span>{translate key="Price"}:</span>
                            {if $product->specialOffer}
                              <p>
                                <em>{currency value=$product->defaultStock->getSpecialOfferPrice()}</em>
                              </p>

                              <div class="price__additional-info">
                                {if $additional_tax_info == '1'}
                                  {assign var=productTax value=$product->getTax()}
                                  <div class="tax-additional-info">
                                    {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {elseif $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {else}
                                      {translate key="excl. shipping costs"}
                                    {/if}
                                  </div>
                                {/if}

                                {if $product->product->unit_price_calculation && $unit_price_calculation}
                                  {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                  <div class="unit-price-container">
                                    {if $price_mode == '1' || $price_mode == '3'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                        {/if}
                                        )
                                      </i>
                                    {elseif $price_mode == '2'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                        {/if}
                                        )
                                      </i>
                                    {/if}
                                  </div>
                                {/if}
                              </div>

                              {if $isRegularPriceVisible}
                                <p class="price__regular">
                                  {* {translate key="Regular price"}: *}
                                  <del class="price__inactive">{currency value=$product->defaultStock->getPrice()}</del>
                                </p>
                              {/if}

                              {if $showLowestPriceHistory && $isLowestPriceVisible}
                                <div class="f-row clear price__omnibus">
                                  {translate key='Lowest price'}:
                                  <strong class="js__omnibus-price-gross price__inactive">
                                    {currency value=$product->stock->getHistoricalLowestPrice()}
                                  </strong>
                                </div>
                              {/if}

                              {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                <p class="product__currency price__currency">
                                  {translate key="Price"} ({$product->currency->currency->name|escape}):
                                  <em
                                    class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice()}</em>
                                </p>
                              {/if}
                            {else}
                              <p>
                                <em>{currency value=$product->defaultStock->getPrice()}</em>
                              </p>

                              <div class="price__additional-info">
                                {if $additional_tax_info == '1'}
                                  {assign var=productTax value=$product->getTax()}
                                  <div class="tax-additional-info">
                                    {if ($price_mode == '1' || $price_mode == '3') && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                      {translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                    {else}
                                      {translate key="excl. shipping costs"}
                                    {/if}
                                  </div>
                                {/if}

                                {if $product->product->unit_price_calculation && $unit_price_calculation}
                                  {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                  <div class="unit-price-container">
                                    {if $price_mode == '1' || $price_mode == '3'}
                                      <i class="default-currency">
                                        ( 1 {$unit->translation->name} =
                                        {if $product->specialOffer}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                        {else}
                                          {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                        {/if}
                                        )
                                      </i>
                                    {/if}
                                  </div>
                                {/if}
                              </div>

                              {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                <p class="product__currency price__currency">
                                  {translate key="Price"} ({$product->currency->currency->name|escape}):
                                  <em
                                    class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice()}</em>
                                </p>
                              {/if}
                            {/if}
                          {/if}

                          {if $price_mode == '1' || $price_mode == '2'}
                            {if $price_mode == '1'}
                              <i class="price-netto">
                              {/if}
                              {if $product->specialOffer}
                                <p>
                                  {if $price_mode == '1'}
                                    {translate key="Net price"}:
                                  {/if}
                                  <em>{currency value=$product->defaultStock->getSpecialOfferPrice(true)}</em>
                                </p>

                                <div class="price__additional-info">

                                  {if $additional_tax_info == '2' && $price_mode == '2'}
                                    {assign var=productTax value=$product->getTax()}
                                    <div class="tax-additional-info">
                                      {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                        {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                      {else}
                                        {translate key="excl. shipping costs"}
                                      {/if}
                                    </div>
                                  {/if}

                                  {if $product->product->unit_price_calculation && $unit_price_calculation}
                                    {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                    <div class="unit-price-container">
                                      {if $price_mode == '2'}
                                        <i class="default-currency">
                                          ( 1 {$unit->translation->name} =
                                          {if $product->specialOffer}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                          {else}
                                            {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                          {/if}
                                          )
                                        </i>
                                      {/if}
                                    </div>
                                  {/if}
                                </div>

                                {if $price_mode == '2'}
                                  {if $isRegularPriceVisible}
                                    <p class="price__regular">
                                      {translate key="Regular price"}:
                                      <del class="price__inactive">{currency value=$product->defaultStock->getPrice(true)}</del>
                                    </p>
                                  {/if}

                                  {if $showLowestPriceHistory && $isLowestPriceVisible}
                                    <div class="f-row clear price__omnibus">
                                      {translate key='Lowest price'}:
                                      <strong class="js__omnibus-price-gross price__inactive">
                                        {currency value=$product->stock->getHistoricalLowestPrice(true)}
                                      </strong>
                                    </div>
                                  {/if}

                                  {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                    <p class="product__currency price__currency">
                                      {translate key="Price"} ({$product->currency->currency->name|escape}):
                                      <em
                                        class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice(true)}</em>
                                    </p>
                                  {/if}
                                {/if}
                              {else}
                                <p>
                                  {if $price_mode == '1'}
                                    {translate key="Net price"}:
                                  {/if}
                                  <em>{currency value=$product->defaultStock->getPrice(true)}</em>
                                </p>

                                {if $price_mode == '2'}
                                  <div class="price__additional-info">
                                    {if $additional_tax_info == '1'}
                                      {assign var=productTax value=$product->getTax()}
                                      <div class="tax-additional-info">
                                        {if $price_mode == '2' && $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                          {translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}
                                        {else}
                                          {translate key="excl. shipping costs"}
                                        {/if}
                                      </div>
                                    {/if}

                                    {if $product->product->unit_price_calculation && $unit_price_calculation}
                                      {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                      <div class="unit-price-container">
                                        {if $price_mode == '2'}
                                          <i class="default-currency">
                                            ( 1 {$unit->translation->name} =
                                            {if $product->specialOffer}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                            {else}
                                              {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                            {/if}
                                            )
                                          </i>
                                        {/if}
                                      </div>
                                    {/if}
                                  </div>

                                  {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                    <p class="product__currency price__currency">
                                      {translate key="Price"} ({$product->currency->currency->name|escape}):
                                      <em
                                        class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice(true)}</em>
                                    </p>
                                  {/if}
                                {/if}
                              {/if}
                              {if $price_mode == '1'}
                              </i>
                            {/if}
                          {/if}
                        {/if}
                      {/if}
                    </div>
                  </div> -->
                </div>

                <div class="buttons f-row">
                  {if $enablebasket && $product->canBuyStock()}
                    {if true == $product->defaultStockOnly()}
                      <form class="basket{if $loyalty_exchange} loyaltyexchange{/if}"
                        action="{route key=$basketAddRoute stockId='post'}" method="post">
                      {else}
                        <form class="basket{if $loyalty_exchange} loyaltyexchange{/if}"
                          action="{route key=$basketAddRoute stockId=$product->defaultStock->getIdentifier()}" method="get">
                        {/if}
                        <fieldset>
                          {if true == $product->defaultStockOnly()}
                            <div class="shaded_inputwrap"><input name="quantity"
                                value="{float precision=$QUANTITY_PRECISION value=1 trim=true}" type="text"
                                class="short center"></div>
                            <span class="unit">{$product->unit->translation->name|escape}</span>
                            <input type="hidden" value="{$product->defaultStock->getIdentifier()|escape}" name="stock_id">

                            {foreach from=$product->getOptionsConfigurationStruct() item=option}
                              {if $option.required}
                                <input type="hidden" name="required" value="1">
                                {break}
                              {/if}
                            {/foreach}
                          {/if}

                          {if $product->isBundle()}
                            {assign var=bundleHasVariants value=false}
                            {capture assign=bundle}
                              {strip}
                                [
                                {foreach from=$product->bundle->stocks item=bundleStock name=bundleList key=k}
                                  {assign var=bundleChildren value=$product->bundle->getLogicStockById($bundleStock->getIdentifier())}
                                  {assign var=bundleOptions value=$bundleChildren->product->getOptionsConfigurationStruct()}

                                  {if $bundleChildren->product->product->group_id && count($bundleOptions)}
                                    {assign var=bundleHasVariants value=true}
                                    {break}
                                  {/if}

                                  {if !$smarty.foreach.bundleList.last}
                                    {literal}{{/literal}
                                    "id":{$bundleStock->getIdentifier()},
                                    "stock_id":{$bundleChildren->getIdentifier()},
                                    "stockId":{$bundleChildren->getIdentifier()},
                                    "quantity":{$bundleStock->stock->stock|escape}
                                    {literal}}{/literal},
                                  {else}
                                    {literal}{{/literal}
                                    "id":{$bundleStock->getIdentifier()},
                                    "stock_id":{$bundleChildren->getIdentifier()},
                                    "stockId":{$bundleChildren->getIdentifier()},
                                    "quantity":{$bundleStock->stock->stock|escape}
                                    {literal}}{/literal}
                                  {/if}
                                {/foreach}
                                ]
                              {/strip}
                            {/capture}

                            {if !$bundleHasVariants}
                              <input type="hidden" value="{$bundle|base64_encode}" name="children">
                            {/if}

                          {/if}

                          <!-- {if !$product->isBundle() || !$bundleHasVariants}
                            <button class="addtobasket btn btn-red" type="submit">
                              <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                              <span>{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</span>
                            </button>
                          {else}
                            <a href="{route function=$productRoute key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                              class="btn btn-red">{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</a>
                          {/if} -->
                        </fieldset>
                      </form>
                    {elseif $enable_availability_notifier && $product->isEnabledNotifier()}
                      {dynamic}
                      <form class="availability-notifier">
                        {assign var="availabilityNotifyUser" value=$product->defaultStock->getAvailabilityNotifyByUser()}
                        <fieldset class="availability-notifier-container{if $availabilityNotifyUser != null} none{/if}">
                          <button class="availability-notifier-btn btn btn-red" type="submit"
                            data-is-logged="{if true == $user_logged}true{else}false{/if}"
                            data-stock-id="{$product->defaultStock->getIdentifier()}"
                            data-product-id="{$product->product->product_id}"
                            data-product-name="{$product->translation->name|escape}">
                            <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                            <span>{translate key="Notify of product availability"}</span>
                          </button>
                        </fieldset>
                        {if true == $user_logged}
                          <fieldset
                            class="availability-notifier-unsubscribe-container{if $availabilityNotifyUser == null} none{/if}">
                            <button type="submit" class="availability-notifier-unsubscribe-btn btn btn-red"
                              data-stock-id="{$product->defaultStock->stock->stock_id}">
                              <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                              <span>{translate key="Cancel notify"}</span>
                            </button>
                          </fieldset>
                        {/if}
                      </form>
                      {/dynamic}
                    {/if}

                    <a class="btn large tablet quickview none" {if $enablebasket}data-price="true" {/if}
                      data-eval="{$skin_settings->productdetails->score}" data-id="{$product->product->product_id}">
                      <img class="px1" alt=""
                        src="{baseDir}/libraries/images/1px.gif"><span>{translate key="check more"}</span>
                    </a>
                </div>
              </div>
            </div>

            {if $product->specialOffer || $product->isNew()}
              <ul class="tags">
                {if $product->specialOffer}
                  <li class="promo">
                    <span>{translate key="on sale tag"}</span>
                  </li>
                {/if}

                {if $product->isNew()}
                  <li class="new">
                    <span>{translate key="new product tag"}</span>
                  </li>
                {/if}
              </ul>
            {/if}
          </div>
        {/foreach}
      </div>
      
      <div class="box__product-categories">
      {if count($headerlinks)}
        {foreach from=$headerlinks item=link}
          {if $link->getHref() || $link->isActiveCategory()}
          <div class="box__product-categories--box">
            <div class="box__product-categories--content">
              <h3>{$link->getTitle()|escape}</h3>
              <p>
                {if $link->getCategoryId() == 38}Przelew | Aeropress | Frenchpress{/if}
                {if $link->getCategoryId() == 39}Kolba | Automat | Kawiarka{/if}
                {if $link->getCategoryId() == 40}Filtry | Merch | Inne{/if}
              </p>
            </div>
            <div class="button_wrap">
              <a class="btn btn-red" 
                {if $link->isCategory()}id="hcategory_{$link->getCategoryId()|escape}" {/if}
                href="{$link->getHref($view)|escape}"
                title="{$link->getTitle()|escape}" 
                id="headlink{$link->getIdentifier()}" 
                class="categories__item"
              >Zobacz</a>
            </div>
          </div>
          {/if}
        {/foreach}
      {/if}
      </div>
{/if}