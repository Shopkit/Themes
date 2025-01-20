{#
Description: Register page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="{{ layout_container }}">
        <h1 class="margin-bottom">{{ 'lang.storefront.login.signup.title'|t }}</h1>

        <ol class="breadcrumb margin-bottom hidden-xs">
            <li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
            <li class="active">{{ 'lang.storefront.login.signup.title'|t }}</li>
        </ol>

        {% if errors.form %}
            <div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
                <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
                {{ errors.form }}
            </div>
        {% endif %}

        <div class="callout callout-danger shopkit-auth-callout hidden {{ store.theme_options.well_danger_shadow }}">
            <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
        </div>

        <div class="row">
            <div class="shopkit-auth-form-register-section">

                <div class="col-xs-12 col-lg-6">
                    <div class="user-login-register well well-default {{ store.theme_options.well_default_shadow }}">
                        <div class="login-register-title text-center margin-bottom">
                            <h2 class="title">{{ 'lang.storefront.login.signup.title'|t }}</h2>
                            <p class="desc">{{ 'lang.storefront.signin.no_account.text'|t }} {{ 'lang.storefront.signin.no_account.signup'|t }}</p>
                        </div>
                        <div class="login-register-form">
                            {{ form_open(site_url('signup/post'), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-signup ignore-ajax' }) }}
                                <div class="row">
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="text" name="shopkit-auth-name" id="shopkit-auth-name" placeholder="{{ 'lang.storefront.form.name.label'|t }}" class="form-control" required>
                                    </div>
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="email" name="shopkit-auth-email" id="shopkit-auth-email" placeholder="{{ 'lang.storefront.form.email.label'|t }}" class="form-control" required>
                                    </div>
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="password" name="shopkit-auth-password" id="shopkit-auth-password" placeholder="{{ 'lang.storefront.form.password.label'|t }}" class="form-control" required>
                                    </div>

                                    {% if apps.newsletter %}
                                        <div class="col-sm-12">
                                            <div class="checkbox">
                                                <label class="margin-0">
                                                    <input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1">
                                                    {{ apps.newsletter.label }}
                                                </label>
                                            </div>
                                        </div>
                                    {% endif %}

                                    {% if store.settings.wholesale.client_signup %}
                                        <div class="col-sm-12">
                                            <div class="checkbox">
                                                <label class="margin-0">
                                                    <input type="checkbox" name="shopkit-wholesale-signup" id="shopkit-wholesale-signup" value="1">
                                                    {{ store.settings.wholesale.checkbox_label }}
                                                </label>
                                            </div>
                                        </div>
                                    {% endif %}

                                    {% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
                                        <div class="col-sm-12">
                                            <div class="checkbox">
                                                <label>
                                                    <input type="checkbox" name="shopkit-auth-accept-terms" id="shopkit-auth-accept-terms" value="1" required>
                                                    {% if store.settings.cart.page_terms and store.settings.cart.page_privacy %}
                                                        {{ 'lang.storefront.cart.terms_privacy'|t([store.settings.cart.page_terms.url, store.settings.cart.page_privacy.url]) }}
                                                    {% elseif store.settings.cart.page_terms and not store.settings.cart.page_privacy %}
                                                        {{ 'lang.storefront.cart.terms'|t([store.settings.cart.page_terms.url]) }}
                                                    {% elseif store.settings.cart.page_privacy and not store.settings.cart.terms %}
                                                        {{ 'lang.storefront.cart.privacy'|t([store.settings.cart.page_privacy.url]) }}
                                                    {% endif %}
                                                </label>
                                            </div>
                                        </div>
                                    {% endif %}

                                    <div class="col-sm-12 margin-top margin-bottom">
                                        <div class="g-recaptcha" id="g_recaptcha_signup"></div>
                                    </div>

                                    <div class="col-sm-12 text-center">
                                        <button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-lg shopkit-auth-btn-submit">{{ 'lang.storefront.login.signup.create_account.button'|t }}</button>
                                    </div>
                                </div>
                            {{ form_close() }}
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-6">
                    <div class="shopkit-auth-form-login-info ">
                        <div class="login-register-title text-center">
                            <h2 class="title margin-bottom-lg">{{ 'lang.storefront.signin.login.text'|t }}</h2>
                            <a href="{{ site_url('signin') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-lg">{{ 'lang.storefront.login.signin.title'|t }}</a>
                        </div>
                    </div>
                </div>


            </div>
        </div>

    </div>

{% endblock %}