{#
Description: Account profile page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="account-profile section">
        <div class="{{ layout_container }}">
            <h2 class="account-profile-title title title_mb-lg">{{ 'lang.storefront.account.my_account'|t }}</h2>

            <div class="row">
                <div class="col-lg-3">
                    {{ account_macros.account_navigation() }}
                </div>

                <div class="col-lg-9">
                    <h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

                    {% if errors.form %}
                        <div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
                            <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
                            {{ errors.form }}
                        </div>
                    {% endif %}

                    {% if events.client.save_profile_success %}
                        <div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
                            <p>{{ 'lang.storefront.layout.events.client.save_profile_success'|t }}</p>
                        </div>
                    {% endif %}

                    {{ form_open('account/save-profile', {'role': 'form'}) }}
                        <h3 class="margin-bottom margin-top-0">{{ 'lang.storefront.layout.client.title'|t }}</h3>
                        <div class="row">
                            <div class="col-sm-6 margin-bottom-sm">
                                <div class="form-group">
                                    <label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                    <input type="text" name="name" id="name" class="form-control" value="{{ user.name }}" required>
                                </div>
                            </div>
                            <div class="col-sm-6 margin-bottom-sm">
                                <div class="form-group">
                                    <label for="email">{{ 'lang.storefront.form.email.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                    <input type="email" name="email" id="email" class="form-control" value="{{ user.email }}" required>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            {% if store.settings.cart.field_company != 'hidden' %}
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="company">{{ 'lang.storefront.order.client.company'|t }} {{ store.settings.cart.field_company == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                        <input type="text" name="company" id="company" class="form-control" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
                                    </div>
                                </div>
                            {% endif %}

                            {% if store.settings.cart.field_fiscal_id != 'hidden' %}
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                        <input type="text" name="fiscal_id" id="fiscal_id" class="form-control" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
                                    </div>
                                </div>
                            {% endif %}
                        </div>

                        <div class="row">
                            <div class="col-sm-6 margin-bottom-sm">
                                <div class="form-group">
                                    <label for="locale">{{ 'lang.storefront.form.language.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                    <select name="locale" id="locale" class="form-control" required>
                                        {% for key, name in locales %}
                                            <option value="{{ key }}" {% if user.locale == key %} selected {% endif %}>{{ name }}</option>
                                        {% endfor %}
                                    </select>
                                </div>
                            </div>
                            <div class="col-sm-6 margin-bottom-sm">
                                <div class="form-group">
                                    <label for="gender">{{ 'lang.storefront.form.gender.label'|t }}</label>
                                    <select name="gender" id="gender" class="form-control">
                                        <option value=""></option>
                                        <option value="female" {% if user.gender == 'female' %} selected {% endif %}>{{ 'lang.storefront.form.gender.female'|t }}</option>
                                        <option value="male" {% if user.gender == 'male' %} selected {% endif %}>{{ 'lang.storefront.form.gender.male'|t }}</option>
                                        <option value="other" {% if user.gender == 'other' %} selected {% endif %}>{{ 'lang.storefront.form.gender.other'|t }}</option>
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-6 margin-bottom-sm">
                                <div class="form-group">
                                    <label for="birthday">{{ 'lang.storefront.form.birthday.label'|t }}</label>
                                    <input type="date" name="birthday" id="birthday" class="form-control" value="{{ user.birthday }}">
                                </div>
                            </div>
                            <div class="col-sm-6 margin-bottom-sm">
                                {% if apps.newsletter %}
                                    <label for="locale">{{ 'lang.storefront.form.newsletter.label'|t }}</label>
                                    <div class="checkbox">
                                        <label>
                                            <input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}>
                                            {{ apps.newsletter.label }}
                                        </label>
                                    </div>
                                {% endif %}
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="password">{{ 'lang.storefront.form.password.label'|t }}</label>
                                    <input type="password" name="password" id="password" class="form-control">
                                </div>
                            </div>
                            <div class="col-sm-6">
                                <div class="form-group">
                                    <label for="repeat_password">{{ 'lang.storefront.form.repeat_password.label'|t }}</label>
                                    <input type="password" name="repeat_password" id="repeat_password" class="form-control">
                                </div>
                            </div>
                        </div>

                        <h3 class="margin-bottom margin-top-sm">{{ 'lang.storefront.order.delivery.address'|t }}</h3>
                        <div class="delivery-info">
                            <div class="row">
                                <div class="col-sm-8 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="delivery_name" id="delivery_name" class="form-control" value="{{ user.delivery.name|default(user.name) }}" required>
                                    </div>
                                </div>
                                {% if store.settings.cart.field_delivery_phone != 'hidden' %}
                                    <div class="col-sm-4 margin-bottom-sm">
                                        <div class="form-group">
                                            <label for="delivery_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                            <input type="tel" name="delivery_phone" id="delivery_phone" class="form-control intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_delivery_phone == 'required' ? 'required' }}>
                                        </div>
                                    </div>
                                {% endif %}
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group">
                                        <label for="delivery_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <div class="row">
                                            <div class="col-sm-8 margin-bottom-sm">
                                                <input type="text" id="delivery_address" class="form-control" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="delivery_address" value="{{ user.delivery.address }}" data-places="route" required>
                                            </div>
                                            <div class="col-sm-4 margin-bottom-sm">
                                                <input type="text" class="form-control" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="delivery_address_extra" id="delivery_address_extra" value="{{ user.delivery.address_extra }}" autocomplete="off">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="delivery_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="delivery_zip_code" id="delivery_zip_code" class="form-control" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
                                    </div>
                                </div>
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="delivery_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="delivery_city" id="delivery_city" class="form-control" value="{{ user.delivery.city }}" data-places="locality" required>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="delivery_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <select name="delivery_country" id="delivery_country" class="form-control" required>
                                            <option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
                                            {% for key, country in countries %}
                                                <option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
                                            {% endfor %}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <h3 class="margin-bottom margin-top-sm">{{ 'lang.storefront.order.billing.address'|t }}</h3>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if user.billing.same_as_delivery %} checked {% endif %} data-target=".billing-info">
                                {{ 'lang.storefront.order.billing_info_same_delivery'|t }}
                            </label>
                        </div>
                        <div class="{% if user.billing.same_as_delivery %}d-none{% endif %} billing-info margin-top">
                            <div class="row">
                                <div class="col-sm-8 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="billing_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="billing_name" id="billing_name" class="form-control" value="{{ user.billing.name }}">
                                    </div>
                                </div>
                                {% if store.settings.cart.field_billing_phone != 'hidden' %}
                                    <div class="col-sm-4 margin-bottom-sm">
                                        <div class="form-group">
                                            <label for="billing_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                            <input type="tel" name="billing_phone" id="billing_phone" class="form-control intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}">
                                        </div>
                                    </div>
                                {% endif %}
                            </div>

                            <div class="row">
                                <div class="col-sm-12">
                                    <div class="form-group">
                                        <label for="billing_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <div class="row">
                                            <div class="col-sm-8 margin-bottom-sm">
                                                <input type="text" id="billing_address" class="form-control" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="billing_address" value="{{ user.billing.address }}" data-places="route">
                                            </div>
                                            <div class="col-sm-4 margin-bottom-sm">
                                                <input type="text" class="form-control" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="billing_address_extra" id="billing_address_extra" value="{{ user.billing.address_extra }}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="billing_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="billing_zip_code" id="billing_zip_code" class="form-control" value="{{ user.billing.zip_code }}" data-places="postal_code">
                                    </div>
                                </div>
                                <div class="col-sm-6 margin-bottom-sm">
                                    <div class="form-group">
                                        <label for="billing_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <input type="text" name="billing_city" id="billing_city" class="form-control" value="{{ user.billing.city }}" data-places="locality">
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col">
                                    <div class="form-group">
                                        <label for="billing_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                        <select name="billing_country" id="billing_country" class="form-control">
                                            <option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
                                            {% for key, country in countries %}
                                                <option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
                                            {% endfor %}
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <footer class="margin-top clearfix account-profile-footer">
                            <div>
                                <a href="{{ site_url('account/delete') }}" class="text-danger small" onclick="return confirm('{{ 'lang.storefront.account.profile.delete_account.confirm'|t }}')">{{ icons('trash-alt') }} {{ 'lang.storefront.account.profile.delete_account.text'|t }}</a>
                            </div>
                            <button class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.account.profile.save_data'|t }}</button>
                        </footer>
                    {{ form_close() }}
                </div>
            </div>
        </div>
    </div>

{% endblock %}