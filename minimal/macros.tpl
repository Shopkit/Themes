{# Macros #}
{% macro product_list(product) %}
    {% import _self as generic_macros %}

    {% set product_title = product.title|e_attr %}
    {% set product_url = product.url %}

    <article class="product product-id-{{ product.id }} {% if product.status_alias == 'out_of_stock' %}out_of_stock{% endif %}" data-id="{{ product.id }}">
        <span class="product-badges">
            {% if product.status_alias == 'out_of_stock' %}
                <span class="out_of_stock">Sem stock</span>
            {% elseif product.status_alias == 'soon' %}
                <span class="soon">Brevemente</span>
            {% elseif product.promo == true %}
                <span class="promo">Promoção</span>
                {% if product.price_promo_percentage == true %}
                    <span class="product-promo-percent promo-percentage">-<span>{{ product.price_promo_percentage }}</span>%</span>
                {% endif %}
            {% elseif product.new == true %}
                <span class="new">Novidade</span>
            {% endif %}
        </span>

        <a href="{{ product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" class="img-responsive lazy" alt="{{ product_title }}" title="{{ product_title }}" width="400" height="400"></a>

        <div class="product-info">
            <a class="product-details" href="{{ product_url }}">
                <div>
                    <h2>{{ product_title }}</h2>

                    <span class="price">
                        {% if product.price_on_request == true %}
                            Preço sob consulta
                        {% else %}
                            {% if product.promo == true %}
                                 {{ product.price_promo | money_with_sign }} <del>{{ product.price | money_with_sign }}</del>
                            {% else %}
                                {{ product.price | money_with_sign }}
                            {% endif %}
                        {% endif %}
                    </span>
                </div>
            </a>
        </div>

    </article>

{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
    {% import _self as generic_macros %}

    {% set category_title = category.title|e_attr %}
    {% set category_url = category.url %}

    <article class="category category-id-{{ category.id }}">

        <a href="{{ category_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image.square }}" class="img-responsive lazy" alt="{{ category_title }}" title="{{ category_title }}" width="400" height="400"></a>

        <div class="category-info">
            <a class="category-details" href="{{ category_url }}">
                <div>
                    <h2>{{ category_title }}</h2>
                    {% if not category.parent == 0 and category.children and show_number_products %}
                        <p>{{ category.children|length }} Categorias</p>
                    {% elseif show_number_products %}
                        <p class="total-products">{{ category.total_products }} Produtos</p>
                    {% endif %}
                </div>
            </a>
        </div>

    </article>
{% endmacro %}
