{#
Description: Register page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.login.signup.title'|t }}</li>
	</ul>

    <h1 class="margin-bottom">{{ 'lang.storefront.login.signup.title'|t }}</h1>

    {% if errors.form %}
        <div class="alert alert-error {{ store.theme_options.well_danger_shadow }}">
            <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
            {{ errors.form }}
        </div>
    {% endif %}

    <div class="alert alert-error {{ store.theme_options.well_danger_shadow }} shopkit-auth-callout hidden">
        <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
    </div>

    <div class="row-fluid">
        <div class="shopkit-auth-form-register-section">

        <div class="span6">
            <div class="user-login-register well well-featured {{ store.theme_options.well_featured_shadow }}">
                <div class="login-register-title text-center margin-bottom">
                    <h3 class="title">{{ 'lang.storefront.login.signup.title'|t }}</h3>
                    <p class="desc">{{ 'lang.storefront.signin.no_account.text'|t }} {{ 'lang.storefront.signin.no_account.signup'|t }}</p>
                </div>
                <div class="login-register-form">
                    {{ form_open(site_url('signup/post'), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-signup ignore-ajax' }) }}
                        <div class="row-fluid">
                            <div class="span12 margin-bottom-sm">
                                <input type="text" name="shopkit-auth-name" id="shopkit-auth-name" placeholder="{{ 'lang.storefront.form.name.label'|t }}" class="input-block-level" required>
                            </div>
                        </div>
                        <div class="row-fluid">
                            <div class="span12 margin-bottom-sm">
                                <input type="email" name="shopkit-auth-email" id="shopkit-auth-email" placeholder="{{ 'lang.storefront.form.email.label'|t }}" class="input-block-level" required>
                            </div>
                        </div>
                        <div class="row-fluid">
                            <div class="span12 margin-bottom-sm">
                                <input type="password" name="shopkit-auth-password" id="shopkit-auth-password" placeholder="{{ 'lang.storefront.form.password.label'|t }}" class="input-block-level" required>
                            </div>
                        </div>

                        {% if apps.newsletter %}
                            <div class="row-fluid">
                                <div class="span12">
                                    <div class="checkbox">
                                        <label class="margin-0">
                                            <input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1">
                                            {{ apps.newsletter.label }}
                                        </label>
                                    </div>
                                </div>
                            </div>
                        {% endif %}

                        {% if store.settings.wholesale.client_signup %}
                            <div class="row-fluid">
                                <div class="span12">
                                    <div class="checkbox">
                                        <label class="margin-0">
                                            <input type="checkbox" name="shopkit-wholesale-signup" id="shopkit-wholesale-signup" value="1">
                                            {{ store.settings.wholesale.checkbox_label }}
                                        </label>
                                    </div>
                                </div>
                            </div>
                        {% endif %}

                        {% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
                            <div class="row-fluid">
                                <div class="span12">
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
                            </div>
                        {% endif %}

                        <div class="row-fluid">
                            <div class="span12 margin-top margin-bottom">
                                <div class="g-recaptcha" id="g_recaptcha_signup"></div>
                            </div>

                            <div class="span12 text-center">
                                <button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} shopkit-auth-btn-submit">{{ 'lang.storefront.login.signup.create_account.button'|t }}</button>
                            </div>
                        </div>
                    {{ form_close() }}
                </div>
            </div>
        </div>

        <div class="span6">
            <div class="shopkit-auth-form-login-info ">
                <div class="login-register-title text-center">
                            <h3 class="title margin-bottom-lg">{{ 'lang.storefront.signin.login.text'|t }}</h3>
                            <a href="{{ site_url('signin') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ 'lang.storefront.login.signin.title'|t }}</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{% endblock %}