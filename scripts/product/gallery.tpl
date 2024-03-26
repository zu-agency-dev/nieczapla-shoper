<div class="productimg f-grid-6{if $visibility.gallery_and_name_gray} product_inactive{/if}">
    <div class="mainimg productdetailsimgsize row">
        {if count($galleryGfxs)}
            {assign var=img value=$galleryGfxs.0}
        {/if}

        {if 1 == count($galleryGfxs)}
            <a 
                id="prodimg{$img->getIdentifier()}"
                href="{imageUrl type='productGfx' image=$img->gfx->unic_name}"
                title="{$img->translation->name|escape}"
                {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_OLD')}
                    data-gallery="true"
                    data-gallery-list="{$product->translation->name|escape}"
                {else}
                    class="js__gallery-anchor-image"
                {/if}>
                    <link 
                        itemprop="image" 
                        href="{imageUrl type='productGfx' image=$img->gfx->unic_name}" />

                    <img 
                        class="photo {if 1 == (int) $skin_settings->productdetails->productzoom}innerzoom {elseif 2 == (int) $skin_settings->productdetails->productzoom}outerzoom {/if} {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}js__open-gallery {/if}" 
                        src="{imageUrl type='productGfx' width=$skin_settings->img->big height=$skin_settings->img->big image=$img->gfx->unic_name}"
                        width="{imageWidth gfx=$img thumbnailSize=$skin_settings->img->big}"
                        height="{imageHeight gfx=$img thumbnailSize=$skin_settings->img->big}"
                        alt="{$img->translation->name|escape}"
                        {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
                            data-gallery-name="productGallery"
                            data-image-description="{$img->translation->name|escape}" 
                        {/if} />
            </a>
        {else}
            <img 
                class="photo {if 1 == (int) $skin_settings->productdetails->productzoom}innerzoom {elseif 2 == (int) $skin_settings->productdetails->productzoom}outerzoom {/if}productimg {if $product->defaultStock->mainImageId()} gallery_{$product->defaultStock->mainImageId()}{/if} {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}js__open-gallery {/if}" 
                src="{imageUrl type='productGfx' width=$skin_settings->img->big height=$skin_settings->img->big image=$product->defaultStock->mainImageName() overlay=1}"
                width="{imageWidth gfx=$img thumbnailSize=$skin_settings->img->big}"
                height="{imageHeight gfx=$img thumbnailSize=$skin_settings->img->big}"
                alt="{$img->translation->name|escape}"
                {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
                    data-gallery-name-to-open="productGallery" 
                {/if} />
        {/if}

        {if $product->specialOffer || $product->isNew()}
            <ul class="tags">
                {if $product->specialOffer}
                    <li class="promo">
                        {translate key="on sale tag"}
                    </li>
                {/if}

                {if $product->isNew()}
                    <li class="new">
                        {translate key="new product tag"}
                    </li>
                {/if}
            </ul>
        {/if}
    </div>
        
    <div class="smallgallery row">
        {if count($galleryGfxs) > 1 && 0 == (int) $skin_settings->productdetails->miniaturesposition}
            <div class="innersmallgallery">
                <ul class="r--l-flex r--l-flex-wrap">
                    {foreach from=$galleryGfxs item=img}
                        {assign var=imgId value=$img->getIdentifier()}

                        <li class="r--l-flex r--l-flex-vcenter">
                            <a 
                                id="prodimg{$img->getIdentifier()}" 
                                href="{imageUrl type='productGfx' image=$img->gfx->unic_name}" 
                                title="{$img->translation->name|escape}"
                                {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_OLD')}
                                    data-gallery="true"
                                    data-gallery-list="{$product->translation->name|escape}" 
                                {/if}
                                class="gallery {if $img->getIdentifier() == $product->defaultStock->mainImageId()} current{/if} {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}js__gallery-anchor-image{/if}">
                                    <link 
                                        itemprop="image" 
                                        href="{imageUrl type='productGfx' image=$img->gfx->unic_name}" />

                                    <img 
                                        src="{imageUrl type='productGfx' width=$skin_settings->img->mini height=$skin_settings->img->mini image=$img->gfx->unic_name}"
                                        width="{imageWidth gfx=$img thumbnailSize=$skin_settings->img->mini}"
                                        height="{imageHeight gfx=$img thumbnailSize=$skin_settings->img->mini}"
                                        alt="{$img->translation->name|escape}" 
                                        data-img-name="{imageUrl type='productGfx' width=$skin_settings->img->big height=$skin_settings->img->big image=$img->gfx->unic_name}"
                                        {if $skin_settings->productdetails->galleryversion == constant('Logic_SkinVariant::GALLERY_NEW')}
                                            class="js__open-gallery" 
                                            data-gallery-name="productGallery"
                                            data-image-description="{$img->translation->name|escape}"
                                        {/if} />
                            </a>
                        </li>
                    {/foreach}
                </ul>

                <nav class="hide">
                    <span class="smallgallery-left none"></span>
                    <span class="smallgallery-right"></span>
                </nav>
            </div>
        {/if}
    </div>
</div>
