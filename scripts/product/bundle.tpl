{* TODO: isComposable *}
<div 
	class="box tab" 
	id="box_bundle" 
	data-composing="0" 
	data-composing-limit="5" 
	data-bundle-items="{$product->bundle->items|@count}">
		<div class="boxhead">
			<h3>
				<img src="{baseDir}/libraries/images/1px.gif" alt="" class="px1">
				{translate key="Bundled products"}
			</h3>
		</div>

		<p class="bundle-with-variants">
			{translate key="To add bundle to the basket, select all the required variants of each item."}
		</p>

		<div class="innerbox">
			{foreach from=$product->bundle->stocks item=bundleStock key=k}
				{assign var=item value=$product->bundle->getLogicStockById($bundleStock->getIdentifier())}
				{assign var=options value=$item->product->getOptionsConfigurationStruct()}

				<div 
					data-bundle-id="{$bundleStock->getIdentifier()}" 
					data-stock-id="{$item->getIdentifier()}" 
					data-has-variants="{if $item->product->product->group_id && count($options)}1{else}0{/if}" 
					class="product row">
						<div class="f-row">
							<h3 class="rwd-show-medium rwd-hide-full">
								<a 
									href="{route function='product' key=$item->product->getIdentifier() productName=$item->product->translation->name productId=$item->product->getIdentifier()}" 
									title="{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}">
										{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}
								</a>
							</h3>

							<div>
								<a 
									href="{imageUrl type='productGfx' image=$item->mainImageName()}" 
									title="{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}"
									{if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_OLD')}
										data-gallery="true" 
										data-gallery-list="{$item->product->translation->name|escape}-{$bundleStock->getIdentifier()}"
									{/if} 
									class="details f-grid-2 {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}js__gallery-anchor-image{/if}">
										<img 
											src="{imageUrl width=$skin_settings->img->small height=$skin_settings->img->small type='productGfx' image=$item->mainImageName() overlay=1}" 
											alt="{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}"
											{if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
												class="js__open-gallery" 
												data-gallery-name="productBundle{$bundleStock->getIdentifier()}Gallery"
												data-image-description="{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}"
											{/if} />

										{if count($item->product->galleryGfxs) > 1}
											<span
												{if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
													data-gallery-name-to-open="productBundle{$bundleStock->getIdentifier()}Gallery" 
												{/if} >
													{translate key="see gallery"} ({$item->product->galleryGfxs|@count})
											</span>
										{/if}
								</a>

								{if count($item->product->galleryGfxs) > 1}
									<div class="none">
										{foreach from=$item->product->galleryGfxs item=img}
											{if $img->product->mainImageId() != $img->gfx->gfx_id}
												<a 
													href="{imageUrl type='productGfx' image=$img->gfx->unic_name}" 
													title="{$img->translation->name|escape}"
													{if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_OLD')}
														data-gallery="true" 
														data-gallery-list="{$item->product->translation->name|escape}-{$bundleStock->getIdentifier()}" 
													{else}
														class="js__gallery-anchor-image"
													{/if}>
														<img 
															src="{imageUrl type='productGfx' width=$skin_settings->img->small height=$skin_settings->img->small image=$img->gfx->unic_name}" 
															alt="{$img->translation->name|escape}"
															{if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
																data-gallery-name="productBundle{$bundleStock->getIdentifier()}Gallery"
																data-image-description="{$img->translation->name|escape}"
															{/if} />
												</a>
											{/if}
										{/foreach}
									</div>
								{/if}

								<div class="f-grid-10">
									<a class="details row rwd-hide-medium rwd-hide-small" href="{route function='product' key=$item->product->getIdentifier() productName=$item->product->translation->name productId=$item->product->getIdentifier()}" title="{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}">
										<span class="productname">{$item->product->translation->name|escape}{if $item->isOption()} ({$item->getName()|escape}){/if}</span>
									</a>

									<p class="manufacturer">
										{translate key="Vendor"}: <strong>{$item->product->producer->manufacturer->name|escape}</strong>
									</p>

									<p class="r--spacing-xs">
										{translate key="Quantity in bundle"}: <span data-quantity>{$bundleStock->stock->stock|escape}</span> {$item->product->unit->translation->name|escape}
									</p>

									<p class="price">
										{if $showprices}
											<p>
												{translate key="The price of product outside the bundle"}

												<span class="default-currency r--fs-l">
													{if $item->isOption()}
														{if $price_mode == 1 || $price_mode == 3}
															{currency value=$item->getPrice()}
														{else}
															{currency value=$item->getPrice(true)}
														{/if}
													{else}
														{if $price_mode == 1 || $price_mode == 3}
															{currency value=$item->product->defaultStock->getPrice()}
														{else}
															{currency value=$item->product->defaultStock->getPrice(true)}
														{/if}
													{/if}
												</span>
											</p>

											<strong>{translate key="Cheaper in the bundle!"}</strong>
										{/if}
									</p>

									<div class="js__prodcut-short-desc description resetcss row">
										{$item->product->translation->short_description}
									</div>

									{if $item->product->product->group_id && count($options)}
										<div class="stocks-bundle" data-stocks="{$item->product->getIdentifier()}">
											{foreach from=$options item=option}
												{if $option.stock == 0}
													{if (0 == $option.stock && count($option.values) > 0) || 1 == $option.stock || $option.type == 'file' || $option.type == 'text' || $option.type == 'checkbox'}
														<div class="stock-control">
															<div class="stock-label">
																{if $option.type == 'checkbox'}
																	<div class="form-control form-control-checkbox variant option-{$option.type|escape}{if 1 == $option.stock} option-truestock{else} option-stock{/if}{if 1 == $option.required} option-required{/if}">
																		<input data-variant-name="{$value.name|escape}" type="checkbox" id="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}" name="option_{$item->getIdentifier()}_{$option.id|escape}_{$bundleStock->getIdentifier()}" value="1" data-variant-id="{$option.id|escape}">
																		<label data-yes="{translate key="YES"}" data-no="{translate key="NO"}" for="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}"></label>
																	</div>
																{/if}
																{if $option.type != 'checkbox'}<span class="label">{translate key="choose"}</span>{/if}
																<span  class="stock-name{if 1 == $option.required} stock-required{/if}">
																	{if $option.type == 'checkbox'}<label for="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}">{/if}{$option.name|escape}{if $option.type == 'checkbox'}</label>{/if}
																</span>
																<span class="selected-value"></span>
															</div>

															{if $option.type != 'checkbox'}
																<div class="stock-options">
																	<div class="form-control variant option-{$option.type|escape}{if 1 == $option.stock} option-truestock{else} option-stock{/if}{if 1 == $option.required} option-required{/if}">
																		{if  $option.type == 'file'}
																			<input type="file" id="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}" name="option_{$item->getIdentifier()}_{$option.id|escape}_{$bundleStock->getIdentifier()}" data-variant-id="{$option.id|escape}">
																		{elseif  $option.type == 'text'}
																			<input type="text" id="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}" name="option_{$item->getIdentifier()}_{$option.id|escape}_{$bundleStock->getIdentifier()}" data-variant-id="{$option.id|escape}">

																			<button class="btn bundle-stock-ok">{translate key="ok"}</button>
																		{elseif  $option.type == 'checkbox'}
																			<span class="checkbox-wrap-yesno">
																				<input data-variant-name="{$value.name|escape}" type="checkbox" id="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}" name="option_{$item->getIdentifier()}_{$option.id|escape}_{$bundleStock->getIdentifier()}" value="1" data-variant-id="{$option.id|escape}">
																				<label data-yes="{translate key="YES"}" data-no="{translate key="NO"}" for="option-{$item->getIdentifier()}-{$option.id|escape}-{$bundleStock->getIdentifier()}"></label>
																			</span>
																		{elseif  $option.type == 'radio' || $option.type == 'select'}
																			{foreach from=$option.values item=value}
																				<span class="radio-wrap">
																					<input data-variant-name="{$value.name|escape}" type="radio" id="option-{$item->getIdentifier()}-{$option.id|escape}-{$value.id|escape}-{$bundleStock->getIdentifier()}" name="option_{$item->getIdentifier()}_{$option.id|escape}_{$bundleStock->getIdentifier()}" value="{$value.id|escape}" data-variant-id="{$option.id|escape}" data-variant-value="{$value.id|escape}">
																					<label for="option-{$item->getIdentifier()}-{$option.id|escape}-{$value.id|escape}-{$bundleStock->getIdentifier()}"></label>
																				</span>
																				<label for="option-{$item->getIdentifier()}-{$option.id|escape}-{$value.id|escape}-{$bundleStock->getIdentifier()}">{$value.name|escape}</label> <br />
																			{/foreach}
																		{elseif  $option.type == 'color'}
																			{foreach from=$option.values item=value}
																				<span data-color="{$value.color|escape}" data-variant-name="{$value.name|escape}" class="product-option_color" data-stock-option title="{$value.name|escape}" data-variant-id="{$option.id|escape}" data-variant-value="{$value.id|escape}" style="background-color: {$value.color|escape}"></span>
																			{/foreach}
																		{/if}
																	</div>
																</div>
															{/if}
														</div>
													{/if}
												{/if}
											{/foreach}
										</div>
									{/if}
								</div>
							</div>
						</div>
				</div>
			{/foreach}
		</div>
</div>