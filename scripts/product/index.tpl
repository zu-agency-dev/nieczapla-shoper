{include file='header.tpl'}

<body{if $body_id} id="{$body_id|escape}" {/if}{if $body_class} class="{$body_class|escape}" {/if}>
  {include file='body_head.tpl'}
  <div class="main row">
    <div class="innermain container">
      <div class="s-row">
        {if 0 < $boxes_left_side|@count}
          <div class="leftcol large s-grid-3">
            {boxesLeft}
          </div>
        {/if}

        <div
          class="centercol {if ($boxes_left_side|@count == 0) and ($boxes_right_side|@count == 0)}s-grid-12{elseif 0 != $boxes_left_side|@count and $boxes_right_side|@count != 0}s-grid-6{else}s-grid-9{/if}"
          itemscope itemtype="{$schema}://schema.org/Product">
          {if $boxes_top_side|@count > 0}
            <div data-boxes-side="0">
              {boxesTop}
            </div>
          {/if}

          {if 1 == $product->translation->active || $adminPreview == true}
            <div class="box row" id="box_productfull"
              data-category="{$product->defaultCategory->translation->name|escape}">
              {*
              <div class="boxhead">
                <h1 class="name{if $visibility.gallery_and_name_gray} product_inactive{/if}" itemprop="name">
                {$product->translation->name|escape}
                </h1>
              </div> 
              *}

              <div class="innerbox product-main-box" data-loading="{translate key="File upload in progress"}...">
                <div class="maininfo row">
                  {* <div class="f-row"> *}
                  <div class="zu-grid padding-top-medium">
                    {include file='product/gallery.tpl'}
                    <div class="f-grid-6 product-details__grid">
                      <div class="availability row">
                        {if $product->defaultStock && ( 1 == $skin_settings->productdetails->availability || ( 1 == $skin_settings->productdetails->time && $product->canBuyStock() ) || ( 1 == $skin_settings->productdetails->shippingcost && $product->canBuyStock() && $enablebasket === true )) }
                          {if $product->defaultStock->stock->code}
                            <meta itemprop="sku" content="{$product->defaultStock->stock->code|escape}" />
                          {elseif $product->stock->stock->code}
                            <meta itemprop="sku" content="{$product->stock->stock->code|escape}" />
                          {/if}

                          {if $product->defaultStock->stock->ean}
                            <meta itemprop="gtin" content="{$product->defaultStock->stock->ean|escape}" />
                          {elseif $product->defaultStock->getAdditionalField('isbn')}
                            <meta itemprop="gtin" content="{$product->defaultStock->getAdditionalField('isbn')|escape}" />
                          {elseif $product->stock->stock->ean}
                            <meta itemprop="gtin" content="{$product->stock->stock->ean|escape}" />
                          {elseif $product->stock->getAdditionalField('isbn')}
                            <meta itemprop="gtin" content="{$product->stock->getAdditionalField('isbn')|escape}" />
                          {/if}

                          <div class="row">
                            <div class="boxhead">
                              <h1 class="name{if $visibility.gallery_and_name_gray} product_inactive{/if}" itemprop="name">
                                {$product->translation->name|escape}
                              </h1>
                              {if count($attrs)}
                                <h2 class="subname{if $visibility.gallery_and_name_gray} product_inactive{/if}">
                                  {$attrs[0].value|escape}/{$attrs[1].value|escape}
                                </h2>
                              {/if}
                            </div>
                            <div class="price-delivery__wrapper">
                              {if $loyalty_exchange}
                                <div class="price">
                                  {* <span class="price-name">{translate key="Price"}:</span> *}
                                  <em>
                                    {$product->defaultStock->loyaltyPointsPrice(true)|escape}

                                    {if $product->defaultStock->loyaltyCurrencyPrice() != 0}
                                      + {currency value=$product->defaultStock->loyaltyCurrencyPrice()}
                                    {/if}
                                  </em>
                                </div>
                              {elseif $showprices}
                                {if $price_mode == '1' || $price_mode == '3'}
                                  <div class="price">
                                    <div class="price__container">
                                      {if $price_mode == '1'}
                                        <span class="price-name">{translate key="Gross price"}:</span>
                                      {* {else}
                                        <span class="price-name">{translate key="Price"}:</span> *}
                                      {/if}

                                      {if $product->specialOffer}
                                        <em
                                          class="main-price color">{currency value=$product->defaultStock->getSpecialOfferPrice()}</em>

                                        {if $additional_tax_info == '1'}
                                          {assign var=productTax value=$product->getTax()}
                                          <div class="tax-additional-info tax-gross">
                                            {if $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                              <span>{translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}</span>
                                            {else}
                                              <span>{translate key="excl. shipping costs"}</span>
                                            {/if}
                                          </div>
                                        {/if}

                                        {if $product->product->unit_price_calculation && $unit_price_calculation}
                                          {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                          <div class="unit-price-container gross">
                                            <span class="price-name">&nbsp;</span>
                                            <span class="container">( 1 <span class="unit">{$unit->translation->name}</span> =
                                              <span class="price">
                                                {if $product->specialOffer}
                                                  {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                                {else}
                                                  {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                                {/if}
                                              </span> )</span>
                                          </div>
                                        {/if}

                                        <p class="price__regular">
                                          {* {translate key="Regular price"}: *}
                                          <del class="price__inactive">{currency value=$product->defaultStock->getPrice()}</del>
                                        </p>

                                        <span class="none" itemprop="price">
                                          {currency value=$product->defaultStock->getSpecialOfferPrice() float_currency=true}
                                        </span>

                                        {if $showLowestPriceHistory}
                                          <div class="f-row clear js__omnibus-price-container">
                                            {if $product->defaultStock->productExists30DaysBeforePromotion()}
                                              {translate key='Lowest price since added to the store'}:
                                            {else}
                                              {translate key='The lowest price during 30 days prior to the reduction'}:
                                            {/if}

                                            <strong class="js__omnibus-price-gross price__inactive">
                                              {currency value=$product->stock->getHistoricalLowestPrice()|escape}
                                            </strong>
                                          </div>
                                        {/if}

                                        {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                          <p>
                                            {translate key="Price"} ({$product->currency->currency->name|escape}):
                                            <em
                                              class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice()}</em>
                                          </p>
                                        {/if}
                                      {else}
                                        {feature name="special_offers_stocks_v1" disabled="1"}
                                        <del class="none"></del>
                                        {/feature}

                                        <em class="main-price">{currency value=$product->defaultStock->getPrice()}</em>

                                        {if $additional_tax_info == '1'}
                                          {assign var=productTax value=$product->getTax()}
                                          <div class="tax-additional-info tax-gross">
                                            {if $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                              <span>{translate key="incl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}</span>
                                            {else}
                                              <span>{translate key="excl. shipping costs"}</span>
                                            {/if}
                                          </div>
                                        {/if}

                                        {if $product->product->unit_price_calculation && $unit_price_calculation}
                                          {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                          <div class="unit-price-container gross">
                                            <span class="price-name">&nbsp;</span>
                                            <span class="container">(1 <span class="unit">{$unit->translation->name}</span> =
                                              <span class="price">
                                                {if $product->specialOffer}
                                                  {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice()}
                                                {else}
                                                  {currency value=$product->defaultStock->getUnitPriceCalculationPrice()}
                                                {/if}
                                              </span> )</span>
                                          </div>
                                        {/if}

                                        {feature name="special_offers_stocks_v1"}
                                        <p class="price__regular none">
                                          {translate key="Regular price"}:
                                          <del class="price__inactive"></del>
                                        </p>
                                        {/feature}

                                        <span class="none" itemprop="price">
                                          {currency value=$product->defaultStock->getPrice() float_currency=true}
                                        </span>

                                        {feature name="special_offers_stocks_v1"}
                                        {if $showLowestPriceHistory}
                                          <div class="f-row clear js__omnibus-price-container none">
                                            {if $product->defaultStock->productExists30DaysBeforePromotion()}
                                              {translate key='Lowest price since added to the store'}:
                                            {else}
                                              {translate key='The lowest price during 30 days prior to the reduction'}:
                                            {/if}

                                            <strong class="js__omnibus-price-gross price__inactive">
                                            </strong>
                                          </div>
                                        {/if}
                                        {/feature}

                                        {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                          <p>
                                            {translate key="Price"} ({$product->currency->currency->name|escape}):
                                            <em
                                              class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice()}</em>
                                          </p>
                                        {/if}

                                        {if $product->isBundle() && $original_bundle_products_price !== false}
                                          <p class="original-bundle-price">
                                            {translate key="The price of products outside the bundle"}:
                                            {currency value=$original_bundle_products_price}
                                          </p>
                                        {/if}
                                      {/if}
                                    </div>
                                  </div>
                                {/if}

                                {if $price_mode == '1' || $price_mode == '2'}
                                  <div class="price-netto">
                                    <div class="price-netto__container">
                                      {if $price_mode == '1'}
                                        <span class="price-name">{translate key="Net price"}:</span>
                                      {else}
                                        <span class="price-name">{translate key="Price"}:</span>
                                      {/if}

                                      {if $product->specialOffer}
                                        <em class="main-price" {if $price_mode == '1'}class="no-color"
                                          {/if}>{currency value=$product->defaultStock->getSpecialOfferPrice(true)}</em>

                                        {if $additional_tax_info == '1'}
                                          {assign var=productTax value=$product->getTax()}
                                          <div class="tax-additional-info tax-net">
                                            {if $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                              <span>{translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}</span>
                                            {else}
                                              <span>{translate key="excl. shipping costs"}</span>
                                            {/if}
                                          </div>
                                        {/if}

                                        {if $product->product->unit_price_calculation && $unit_price_calculation}
                                          {if $price_mode == '1' || $price_mode == '2'}
                                            {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                            <div class="unit-price-container net">
                                              <span class="price-name">&nbsp;</span>
                                              <span class="container">( 1 <span class="unit">{$unit->translation->name}</span> =
                                                <span class="price">
                                                  {if $product->specialOffer}
                                                    {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                                  {else}
                                                    {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                                  {/if}
                                                </span> )</span>
                                            </div>
                                          {/if}
                                        {/if}

                                        {feature name="special_offers_stocks_v1"}
                                        <p class="price__regular">
                                          {translate key="Regular price"}:
                                          <del
                                            class="price__inactive">{currency value=$product->defaultStock->getPrice(true)}</del>
                                        </p>
                                        {/feature}

                                        {if $price_mode == '2'}
                                          <span class="none" itemprop="price">
                                            {currency value=$product->defaultStock->getSpecialOfferPrice(true) float_currency=true}
                                          </span>
                                        {/if}

                                        {feature name="special_offers_stocks_v1" disabled="1"}
                                        <p class="price__regular">
                                          {translate key="Regular price"}:
                                          <del
                                            class="price__inactive">{currency value=$product->defaultStock->getPrice(true)}</del>
                                        </p>
                                        {/feature}

                                        {if $showLowestPriceHistory}
                                          <div class="f-row clear js__omnibus-price-container">
                                            {if $product->defaultStock->productExists30DaysBeforePromotion()}
                                              {translate key='Lowest price since added to the store'}:
                                            {else}
                                              {translate key='The lowest price during 30 days prior to the reduction'}:
                                            {/if}

                                            <strong class="js__omnibus-price-net price__inactive">
                                              {currency value=$product->stock->getHistoricalLowestPrice(true)}
                                            </strong>
                                          </div>
                                        {/if}

                                        {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                          <p>
                                            {translate key="Price"} ({$product->currency->currency->name|escape}):
                                            <em
                                              class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencySpecialOfferPrice(true)}</em>
                                          </p>
                                        {/if}
                                      {else}
                                        <em class="main-price" {if $price_mode == '1'}class="no-color"
                                          {/if}>{currency value=$product->defaultStock->getPrice(true)}</em>

                                        {feature name="special_offers_stocks_v1" disabled="1"}
                                        {if $price_mode == '2'}
                                          <span class="none" itemprop="price">
                                            {currency value=$product->defaultStock->getPrice(true) float_currency=true}
                                          </span>
                                        {/if}
                                        {/feature}

                                        {if $additional_tax_info == '1'}
                                          {assign var=productTax value=$product->getTax()}
                                          <div class="tax-additional-info tax-net">
                                            {if $product->defaultStock->getPrice() != $product->defaultStock->getPrice(true)}
                                              <span>{translate key="excl. %s TAX, excl. shipping costs" s1=$productTax->taxValue->name}</span>
                                            {else}
                                              <span>{translate key="excl. shipping costs"}</span>
                                            {/if}
                                          </div>
                                        {/if}

                                        {if $product->product->unit_price_calculation && $unit_price_calculation}
                                          {if $price_mode == '1' || $price_mode == '2'}
                                            {assign var=unit value=$product->defaultStock->getUnitPriceCalculationUnit()}
                                            <div class="unit-price-container net">
                                              <span class="price-name">&nbsp;</span>
                                              <span class="container">( 1 <span class="unit">{$unit->translation->name}</span> =
                                                <span class="price">
                                                  {if $product->specialOffer}
                                                    {currency value=$product->defaultStock->getUnitPriceCalculationSpecialOfferPrice(true)}
                                                  {else}
                                                    {currency value=$product->defaultStock->getUnitPriceCalculationPrice(true)}
                                                  {/if}
                                                </span> )</span>
                                            </div>
                                          {/if}
                                        {/if}

                                        {feature name="special_offers_stocks_v1"}
                                        <p class="price__regular none">
                                          {translate key="Regular price"}:
                                          <del class="price__inactive"></del>
                                        </p>

                                        {if $price_mode == '2'}
                                          <span class="none" itemprop="price">
                                            {currency value=$product->defaultStock->getPrice(true) float_currency=true}
                                          </span>
                                        {/if}

                                        {if $showLowestPriceHistory}
                                          <div class="f-row clear js__omnibus-price-container none">
                                            {if $product->defaultStock->productExists30DaysBeforePromotion()}
                                              {translate key='Lowest price since added to the store'}:
                                            {else}
                                              {translate key='The lowest price during 30 days prior to the reduction'}:
                                            {/if}

                                            <strong class="js__omnibus-price-net price__inactive">
                                            </strong>
                                          </div>
                                        {/if}
                                        {/feature}

                                        {if $product->currency and $currency->getIdentifier() != $product->currency->getIdentifier()}
                                          <p>
                                            {translate key="Price"} ({$product->currency->currency->name|escape}):
                                            <em
                                              class="default-currency">{currency id=$product->product->currency_id rate=1 value=$product->defaultStock->getCurrencyPrice(true)}</em>
                                          </p>
                                        {/if}

                                        {if $product->isBundle() && $original_bundle_products_price !== false}
                                          <p class="original-bundle-price">
                                            {translate key="The price of products outside the bundle"}:
                                            {currency value=$original_bundle_products_net_price}
                                          </p>
                                        {/if}
                                      {/if}
                                    </div>
                                  </div>
                                {/if}

                                {feature name="promotion_time"}
                                {if $product->specialOffer && $skin_settings->productdetails->promotiontime == 1}
                                  <p class="promo-time">
                                    {translate key="The promotion runs until"}
                                    {date value=$product->specialOffer->specialOffer->date_to}
                                  </p>
                                {/if}
                                {/feature}

                                <meta itemprop="priceCurrency" content="{$currency->currency->name|escape}">
                              {/if}
                              {if 1 == $skin_settings->productdetails->availability && $product->defaultStock->availability && $product->defaultStock->availability->translation}
                                <div class="row availability">
                                  <span class="first">{translate key="Availability"}:</span>
                                  {if $product->defaultStock->availability->availability->photo}
                                    <img src="{baseDir}/{$product->defaultStock->availability->getUrl()}" alt="">
                                  {/if}
                                  <span class="second">{$product->defaultStock->availability->translation->name|escape}</span>
                                </div>
                              {/if}

                              <div class="product__price-delivery">
                                {if $product->canBuyStock() && 1 == $skin_settings->productdetails->time && $product->defaultStock->delivery}
                                  <div class="delivery">
                                    <span class="first">{translate key="Dispatched within"}:</span>
                                    <span class="second">{$product->defaultStock->delivery->translation->name|escape}</span>
                                  </div>
                                {/if}

                                {if $product->canBuyStock() && $skin_settings->productdetails->shippingcost == 1 && $enablebasket === true}
                                  <div class="shipping-costs">
                                    <span class="first">{translate key="Delivery"}:</span>

                                    <span class="second">
                                      <span class="lowest-cost"></span>
                                      <span class="lowest-cost-shipping"></span>
                                      <span class="lowest-cost-shipping-country"></span>

                                      <span class="hint">
                                        <span class="icon icon-help"></span>

                                        <span class="hint__content">
                                          {translate key='The price does not include any possible payment costs'}
                                        </span>
                                      </span>
                                    </span>

                                    <a href="#deliveries" title="{translate key="check the delivery methods"}"
                                      class="showShippingCost">
                                      <span>{translate key="check the delivery methods"}</span>
                                    </a>
                                  </div>

                                {/if}
                              </div>
                            </div>
                          </div>
                        {/if}

                        {if $product->product->producer_id}
                          <meta itemprop="brand" content="{$product->producer->manufacturer->name|escape}">
                        {/if}
                      </div>

                      <div class="bottomborder row" itemprop="offers" itemscope itemtype="{$schema}://schema.org/Offer">
                        <link itemprop="url"
                          href="{route full=true function='product' key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}">

                        <div class="basket">
                          {if $product->getRichSnippetForAvailability() == 'instore_only'}
                            <link itemprop="availability" href="{$schema}://schema.org/InStoreOnly" />
                          {elseif $product->getRichSnippetForAvailability() == 'out_of_stock'}
                            <link itemprop="availability" href="{$schema}://schema.org/OutOfStock" />
                          {else}
                            <link itemprop="availability" href="{$schema}://schema.org/InStock" />
                          {/if}

                          {if floatval($product->product->other_price)}
                            <div class="otherprice">
                              <span class="otherprice-name">{translate key="Price in other stores"}:</span>
                              <em>{currency value=$product->product->other_price}</em>
                            </div>
                          {/if}

                          {if count($attrs)}
                            <div class="product-details__table">
                              <p>{$attrs[2].name|escape}</p>
                              <p>{$attrs[2].value|escape}</p>
                            </div>
                            <div class="product-details__table">
                              <p>{$attrs[3].name|escape}</p>
                              <p>{$attrs[3].value|escape}</p>
                            </div>
                            <div class="product-details__table">
                              <p>{$attrs[4].name|escape}</p>
                              <p>{$attrs[4].value|escape}</p>
                            </div>
                          {/if}
                          <form
                            class="form-basket{if false == $product->canBuyStock() && ($enable_availability_notifier && $product->isEnabledNotifier()) == false} none{/if}{if $loyalty_exchange} loyaltyexchange{/if}"
                            method="post" action="{route key=$basketAddRoute stockId='post'}"
                            enctype="multipart/form-data">
                            {assign var=options value=$product->getOptionsConfigurationStruct()}
                            {if $product->product->group_id && count($options)}
                              <div class="stocks">
                                {foreach from=$options item=option}
                                  {if (0 == $option.stock && count($option.values) > 0) || 1 == $option.stock || $option.type == 'file' || $option.type == 'text' || $option.type == 'checkbox'}
                                    <div class="f-row">
                                      <div class="label">
                                        <label for="option_{$option.id|escape}" class="label">
                                          {if 1 == $option.required}
                                            {if $product->canBuyStock()}
                                              {assign var="requiredField" value=true}
                                            {/if}
                                            <em class="color">*</em>
                                          {/if}
                                          {$option.name|escape}:
                                        </label>
                                      </div>
                                      <div class="stock-options">
                                        {if  $option.type == 'file'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            <input type="file" id="option_{$option.id|escape}"
                                              name="option_{$option.id|escape}" />
                                          </div>
                                        {elseif  $option.type == 'text'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            <div class="shaded_inputwrap inputwrap">
                                              <input type="text" id="option_{$option.id|escape}" name="option_{$option.id|escape}"
                                                value="" />
                                            </div>
                                          </div>
                                        {elseif  $option.type == 'checkbox'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            <span class="checkbox-wrap-yesno">
                                              <input type="checkbox" id="option_{$option.id|escape}"
                                                name="option_{$option.id|escape}" value="1" />
                                              <label data-yes="{translate key="YES"}" data-no="{translate key="NO"}"
                                                for="option_{$option.id|escape}"></label>
                                            </span>
                                          </div>
                                        {elseif  $option.type == 'radio'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            {foreach from=$option.values item=value}
                                              <span class="radio-wrap">
                                                <input class="radio-wrap__radio" type="radio"
                                                  id="option_{$option.id|escape}_{$value.id|escape}"
                                                  name="option_{$option.id|escape}" value="{$value.id|escape}"
                                                  {if 1 == $option.stock}{productOptionValueStocksUnavailable product=$product->getIdentifier() optionValue=$value.id}data-unavailable{/productOptionValueStocksUnavailable}{/if} />
                                                <label for="option_{$option.id|escape}_{$value.id|escape}"
                                                  class="radio-wrap__label">{$value.name|escape}</label>
                                              </span>
                                              {* <label for="option_{$option.id|escape}_{$value.id|escape}"
                                                class="radio-wrap__label">{$value.name|escape}</label> *}
                                              {* <br /> *}
                                            {/foreach}
                                          </div>
                                        {elseif  $option.type == 'color'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            <select id="option_{$option.id|escape}" name="option_{$option.id|escape}">
                                              <option value="" title="">{translate key='choose'}</option>
                                              {foreach from=$option.values item=value}
                                                <option value="{$value.id|escape}" title="{$value.color|escape}"
                                                  {if 1 == $option.stock}{productOptionValueStocksUnavailable product=$product->getIdentifier() optionValue=$value.id}data-unavailable{/productOptionValueStocksUnavailable}{/if}>
                                                  {$value.name|escape}</option>
                                              {/foreach}
                                            </select>
                                          </div>
                                        {elseif  $option.type == 'select'}
                                          <div
                                            class="option_{$option.type|escape}{if 1 == $option.stock} option_truestock{/if}{if 1 == $option.required} option_required{/if}">
                                            <select id="option_{$option.id|escape}" name="option_{$option.id|escape}">
                                              {if 0 == $option.stock}
                                                <option value="" title="">{translate key='choose'}</option>
                                              {/if}
                                              {foreach from=$option.values item=value}
                                                <option value="{$value.id|escape}"
                                                  {if 1 == $option.stock}{productOptionValueStocksUnavailable product=$product->getIdentifier() optionValue=$value.id}data-unavailable{/productOptionValueStocksUnavailable}{/if}>
                                                  {$value.name|escape}</option>
                                              {/foreach}
                                            </select>
                                          </div>
                                        {/if}
                                      </div>
                                    </div>
                                  {/if}
                                {/foreach}
                              </div>
                            {/if}

                            <fieldset
                              class="addtobasket-container{if false == $enablebasket || 0 == (int) $product->defaultStock->availability->availability->can_buy} none{/if}">
                              <button type="button" id="minusQuantity" class="btn btn-quantity"><span
                                  class="fa-sharp fa-solid fa-minus"></span></button>
                              <div class="quantity_wrap">
                                <span class="quantity_name">{translate key="quantity"}</span>
                                <span class="number-wrap">
                                  <input name="quantity" value="{float precision=$QUANTITY_PRECISION value=1 trim=true}"
                                    type="{if $product->unit->unit->floating_point == 0}number{else}text{/if}"
                                    class="short inline addtobasket-input-quantity">
                                </span>
                                <span class="unit none">{$product->unit->translation->name|escape}</span>
                                <input type="hidden" value="{$stock_id|escape}" name="stock_id">
                                <input type="hidden" value="{$product->product->product_id}" name="product_id">
                                <input type="hidden" value="1" name="nojs">

                                {if $product->isBundle()}
                                  <input type="hidden" value="{foreach from=$product->bundle->items item=item name=bundles}{$item->getIdentifier()}














                                    {if !$smarty.foreach.bundles.last},













                                    {/if}














                                  {/foreach}" name="bundle_stocks">
                                {/if}
                              </div>
                              <button type="button" id="plusQuantity" class="btn btn-quantity"><span
                                  class="fa-sharp fa-solid fa-plus"></span></button>
                              <div class="button_wrap">
                                <button type="submit" class="addtobasket btn btn-red">
                                  <img src="{baseDir}/libraries/images/1px.gif" alt="{translate key='Add to cart'}"
                                    class="px1">
                                  <span>{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</span>
                                </button>
                                {if false !== $loyalty_points && !$loyalty_exchange}
                                  <span class="loyalty_points{if 0 == $loyalty_points} none{/if}">
                                    {translate key="You gain %s%s%s points [%s?%s]" p1='<span class="points">' p2=$loyalty_points p3='</span>' p4='<span class="tooltip_pointer">' p5='</span>'}
                                    <label class="tooltip" id="loyalty_msg">
                                      {if $loyalty_msg_title}
                                        <span class="title">{$loyalty_msg_title|escape}</span>
                                      {/if}
                                      {foreach from=$loyalty_msgs item=loyalty_msg}
                                        <span>{$loyalty_msg|escape}</span>
                                      {/foreach}
                                    </label>
                                  </span>
                                {/if}
                              </div>
                            </fieldset>

                            {if $enable_availability_notifier}
                              {dynamic}
                              {assign var="availabilityNotifyUser" value=$product->defaultStock->getAvailabilityNotifyByUser()}
                              <fieldset
                                class="availability-notifier-container{if $availabilityNotifyUser != null || 1 == (int) $product->defaultStock->availability->availability->can_buy} none{/if}">
                                <div class="button_wrap">
                                  <button type="submit" class="availability-notifier-btn btn btn-red"
                                    data-is-logged="{if true == $user_logged}true{else}false{/if}"
                                    data-stock-id="{$product->defaultStock->stock->stock_id}"
                                    data-product-id="{$product->product->product_id}"
                                    data-product-name="{$product->translation->name|escape}">
                                    <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                    <span>{translate key="notify of product availability"}</span>
                                  </button>
                                </div>
                              </fieldset>
                              {if true == $user_logged}
                                <fieldset
                                  class="availability-notifier-unsubscribe-container{if $availabilityNotifyUser == null || 1 == (int) $product->defaultStock->availability->availability->can_buy} none{/if}">
                                  <div class="button_wrap">
                                    <button type="submit" class="availability-notifier-unsubscribe-btn btn btn-red"
                                      data-stock-id="{$product->defaultStock->stock->stock_id}">
                                      <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                      <span>{translate key="cancel notify"}</span>
                                    </button>
                                  </div>
                                </fieldset>
                              {/if}
                              {/dynamic}
                            {/if}
                          </form>

                          <p
                            class="center mt-2 r--fs-xl js__product-availability{if !$visibility.additional_text} none{/if}">
                            {translate key="product unavailable"}
                          </p>

                          {if 1 == $skin_settings->productdetails->storage}
                            <a href="{route key='favouriteAdd' stockId=$product->defaultStock->getIdentifier()}"
                              title="{translate key='add to wish list'}" class="addtofav">
                              <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                              <span>{translate key="add to wish list"}</span>
                            </a>
                          {/if}

                          {if $requiredField}
                            <div class="none">
                              <span><em class="color">*</em> - {translate key="Field mandatory"}</span>
                            </div>
                          {/if}
                        </div>

                        {if 1 == $skin_settings->productdetails->score || 1 == $skin_settings->productdetails->producer || 1 == $skin_settings->productdetails->code ||
                                                                                                                                          1 == $skin_settings->productdetails->storage || 1 == $skin_settings->productdetails->recommend || ($can_comment && 1 == $skin_settings->productdetails->comments) }

                        <div class="productdetails-more-details clearfix">
                          {if 1 == $skin_settings->productdetails->score || 1 == $skin_settings->productdetails->producer || 1 == $skin_settings->productdetails->code}
                            <div class="productdetails-more row">
                              {if 1 == $skin_settings->productdetails->score}
                                <div class="row evaluation">
                                  {if !$can_vote}
                                    <em class="vote-message voted-message">{translate key="You already rated"}!</em>
                                  {/if}
                                  <em class="vote-message">{translate key="Rating"}:</em>
                                  <span class="votestars" {if $can_vote} id="votestars_{$product->getIdentifier()|escape}"
                                    {/if}>
                                    {foreach from=$vote_stars item=star name=list}
                                      <img src="{baseDir}/libraries/images/1px.gif" alt=""
                                        class="px1 star{$star|escape|replace:'.':'-'}">
                                    {/foreach}
                                  </span>
                                  <span class="none">
                                    {$product->vote->rate}
                                  </span>
                                </div>
                              {/if}

                              {if 1 == $skin_settings->productdetails->producer}
                                <div class="row manufacturer">
                                  <em>{translate key="Vendor"}: </em>
                                  {if $product->product->producer_id}
                                    {if $product->producer->manufacturer->web}
                                      <a target="_blank" rel="noopener" class="brand"
                                        href="{$product->producer->manufacturer->web}"
                                        title="{$product->producer->manufacturer->name|escape}">
                                      {else}
                                        <a class="brand" href="{route function='producer' key=$product->producer->getIdentifier() producerName=$product->producer->manufacturer->name producerId=$product->producer->getIdentifier()
                                                                                    page=1 sort=1 view=$view}"
                                          title="{$product->producer->manufacturer->name|escape}">
                                        {/if}
                                        {if $product->producer->manufacturer->gfx}
                                          <img src="{baseDir}/{$product->producer->getUrl()}"
                                            alt="{$product->producer->manufacturer->name|escape}" />
                                        {else}
                                          {$product->producer->manufacturer->name|escape}
                                        {/if}
                                      </a>
                                    {else}
                                      -
                                    {/if}
                                </div>
                              {/if}

                              <meta itemprop="category" content="{$product->defaultCategory->translation->name|escape}" />

                              {if 1 == $skin_settings->productdetails->code}
                                <div class="row code">
                                  <em>{translate key="Product code"}:</em>
                                  <span>{$product->getDefaultCode()|escape}</span>
                                </div>
                              {/if}
                            </div>
                          {/if}

                          <ul class="row links-q">
                            {if 1 == $skin_settings->productdetails->question}
                              <li class="question">
                                <a data-href="{route key='productQuestion' productId=$product->getIdentifier()}"
                                  title="{translate key='ask about product'}" class="question ajaxlayer">
                                  <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                  <span>{translate key="ask about product"}</span>
                                </a>
                              </li>
                            {/if}

                            {if 1 == $skin_settings->productdetails->recommend}
                              <li class="mailfriend">
                                <a href="{route key='productMailFriend' productId=$product->getIdentifier()}"
                                  title="{translate key='recommend to a friend'}" class="mailfriend">
                                  <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                  <span>{translate key="recommend to a friend"}</span>
                                </a>
                              </li>
                            {/if}
                            {if false != $product_comments && 1 == $skin_settings->productdetails->comments}
                              {if $can_comment}
                                <li class="comment">
                                  <a href="#commentform" title="{translate key='add your review'}" class="comment addcomment">
                                    <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1" />
                                    <span>{translate key="add your review"}</span>
                                  </a>
                                </li>
                              {else}
                                <li class="comment">
                                  <a href="#" title="{translate key='Only registered users can add reviews.'}"
                                    class="comment addcomment alert-modal">
                                    <img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
                                    <span>{translate key="add your review"}</span>
                                  </a>
                                </li>
                              {/if}
                            {/if}

                            {plugin module=shop template=product-links product=$product}
                          </ul>
                        </div>
                      {/if}

                      {if 1 == $skin_settings->productdetails->fb_like || 1 == $skin_settings->productdetails->pinit || 1 == $skin_settings->productdetails->fb_share}
                        <div class="fb_buttons row">
                          {if 1 == $skin_settings->productdetails->fb_share}
                            <div class="fb-share-button"
                              data-href="{route full=true function='product' key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                              data-layout="button_count" data-size="small">
                            </div>
                          {/if}

                          {if 1 == $skin_settings->productdetails->fb_like}
                            <fb:like
                              href="{route full=true function='product' key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}"
                              send="false" layout="button_count" show_faces="true" width="110" font="tahoma"></fb:like>
                          {/if}

                          {if 1 == $skin_settings->productdetails->pinit && $product->mainGfx->gfx->unic_name}
                            <a href="{if $isHttps}https{else}http{/if}://pinterest.com/pin/create/button/?url={route full=true function='product' key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}&amp;media={imageUrl type='productGfx' image=$product->mainGfx->gfx->unic_name fullurl=true}&amp;description={$product->translation->name|escape}"
                              count-layout="horizontal"><img alt="Pin It"
                                src="//assets.pinterest.com/images/pidgets/pin_it_button.png" title="Pin It" /></a>
                          {/if}
                        </div>
                      {/if}

                      {plugin module=shop template=product-payment-baner}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {if (false !== $product_comments && 1 == $skin_settings->productdetails->comments)
            || (count($related_products) && 1 == $skin_settings->productdetails->related)
            || (count($galleryGfxs) > 1 && 1 == (int) $skin_settings->productdetails->miniaturesposition)
            || strlen(trim($product->translation->description)) || count($product->files)
            || count($attrs)
            || $product->isBundle()
            || $product->canBuyStock() && $skin_settings->productdetails->shippingcost == 1 && $enablebasket === true
          }
          <div class="product-modules{if $skin_settings->productdetails->tabs} active none{/if}">
            {if $product->isBundle()}
              {include file="product/bundle.tpl"}
            {/if}
            {include file="product/description.tpl"}
            {include file="product/attributes.tpl"}
            {include file="product/shipping-costs.tpl"}
            {include file="product/gallery-tab.tpl"}
            {include file="product/related.tpl"}
            {include file="product/comments.tpl"}
          </div>
          {/if}

          {if 1 == $skin_settings->productdetails->fb_chat}
            <div class="box row" id="box_facebookchat"></div>
          {/if}
          {else}
          <div class="alert-error alert">
            <p>{translate key="This product is unavailable."}</p>
          </div>
          {/if}

          {if $boxes_bottom_side|@count > 0}
            <div data-boxes-side="2">
              {boxesBottom}
            </div>
          {/if}
        </div>

        {if 0 < $boxes_right_side|@count}
          <div class="rightcol large s-grid-3">
            {boxesRight}
          </div>
        {/if}
      </div>
    </div>
  </div>

  {if $product->isBundle()}
    <div class="bundle-fixed-cart">
      <div class="bundle-fixed-cart-container{if false == $product->canBuyStock()} none{/if}">
        <div class="bundle-header">
          <span class="bundle-name"><strong>{$product->translation->name|escape}</strong></span>
          <span class="bundle-selected">{translate key="Choose product variants"} (<span
              class="bundle-selected-item">1</span>/{$product->bundle->items|@count})</span>
        </div>

        <div class="bundle-cart">
          <input name="quantity" value="1" type="text" class="fixed-cart-quantity">
          <button id="fixed-cart-add"
            class="btn btn-red">{if $loyalty_exchange}{translate key="Exchange"}{else}{translate key="Add to cart"}{/if}</button>
        </div>
      </div>
    </div>
  {/if}

  <script type="text/javascript">
    try {literal}{{/literal} 
    {literal}
      window.Shop = window.Shop || {};
      window.Shop.values = window.Shop.values || {};
    {/literal}
    Shop.values.OptionsConfiguration = "{$options_configuration|escape}"; 
    Shop.values.OptionsDefault = "{$options_default|escape}"; 
    Shop.values.OptionCurrentStock = "{$stock_id|escape}"; 
    Shop.values.optionCurrentVirt = "default";
    Shop.values.OptionImgWidth = "{$skin_settings->img->big|escape}"; 
    Shop.values.OptionImgHeight = "{$skin_settings->img->big|escape}"; 
    Shop.values.ProductStocksCache = "{$product_stocks_cache|escape}";
    Shop.values.shippingFlagEnabled = "{$enableWarehousesAdditionalShippingTimeTooltip}";
    {literal}}{/literal} catch(e) {literal}{ }{/literal}
  </script>
  {include file='footerbox.tpl'}
  {include file='footer.tpl' force_include_cache='1' force_include_cache_tags='Logic_SkinFooterGroupList,Logic_SkinFooterLinkList,Logic_SkinFooterGroup,Logic_SkinFooterLink'}
  {plugin module=shop template=footer}

  {if $xfbml}
    <script type="text/javascript">
      if($('#box_facebookchat')) $('#box_facebookchat').html('<fb:comments width="' + $('#box_facebookchat').width() + '" href="{route full=true function='product' key=$product->product->product_id productName=$product->translation->name productId=$product->product->product_id}" num_posts="10"></fb:comments>');
    </script>
  {/if}

  {if 1 == $skin_settings->productdetails->pinit}
    {literal}
      <script>
        window.customerPrivacy.onFunctionalConsentGranted(() => {
          (function(d, s) {
            var js, fjs = d.getElementsByTagName(s)[0];
            js = d.createElement(s);
            js.src = "//assets.pinterest.com/js/pinit.js";
            js.crossorigin = 'anonymous';
            fjs.parentNode.insertBefore(js, fjs);
          }(document, 'script'));
        });
      </script>
    {/literal}
  {/if}
  {include file='switch.tpl'}

  {$snippet_product}
  </body>

</html>