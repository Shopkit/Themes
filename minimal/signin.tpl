{#
Description: Login page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="{{ layout_container }}">
        <h1 class="margin-bottom">{{ 'lang.storefront.login.signin.title'|t }}</h1>

        <ol class="breadcrumb margin-bottom hidden-xs">
            <li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
            <li class="active">{{ 'lang.storefront.login.signin.title'|t }}</li>
        </ol>

        {% if errors.form %}
            <div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
                <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
                {{ errors.form }}
            </div>
        {% endif %}

        {% if events.client.recover_password %}
            <div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
                {{ events.client.recover_password }}
            </div>
        {% endif %}

        <div class="row ">
            <div class="shopkit-auth-form-login-section">

                <div class="col-xs-12 col-lg-6">
                    <div class="user-login-register well well-default {{ store.theme_options.well_default_shadow }}">
                        <div class="login-register-title text-center margin-bottom">
                            <h2 class="title">{{ 'lang.storefront.login.signin.title'|t }}</h2>
                            <p class="desc">{{ 'lang.storefront.signin.login.text'|t }}</p>
                        </div>
                        <div class="login-register-form">
                            {{ form_open(site_url('signin/post') ~ (get.next ? '?next=' ~ get.next), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-login ignore-ajax' }) }}
                                <div class="row">
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="email" name="shopkit-auth-email" id="shopkit-auth-email" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" class="form-control" required>
                                    </div>
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="password" name="shopkit-auth-password" id="shopkit-auth-password" placeholder="{{ 'lang.storefront.form.password.label'|t }}" class="form-control" required>
                                    </div>

                                    <div class="col-sm-12 margin-bottom">
                                        <a href="#" class="shopkit-auth-link-recover text-muted text-underline" data-toggle="replace" data-origin=".shopkit-auth-form-login" data-target=".shopkit-auth-form-recover">{{ 'lang.storefront.login.signin.recover_password.button'|t }}</a>
                                    </div>

                                    <div class="col-sm-12 text-center">
                                        <button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-lg">{{ 'lang.storefront.login.signin.login_account.button'|t }}</button>
                                    </div>
                                </div>
                            {{ form_close() }}

                            {{ form_open(site_url('signin/recover_password'), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-recover ignore-ajax hidden' }) }}
                                <div class="row">
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <input type="email" name="shopkit-auth-email" id="shopkit-auth-email-recover" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" class="form-control">
                                    </div>
                                    <div class="col-sm-12 margin-bottom-sm">
                                        <div class="g-recaptcha" id="g_recaptcha_signup"></div>
                                    </div>
                                    <div class="col-sm-12 margin-bottom">
                                        <a href="#" class="shopkit-auth-link-login text-muted text-underline" data-toggle="replace" data-origin=".shopkit-auth-form-recover" data-target=".shopkit-auth-form-login">{{ 'lang.storefront.login.signin.recover_password.back.button'|t }}</a>
                                    </div>
                                    <div class="col-sm-12 text-center">
                                        <button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-lg">{{ 'lang.storefront.login.signin.recover_password.button'|t }}</button>
                                    </div>
                                </div>
                            {{ form_close() }}
                        </div>
                    </div>
                </div>

                <div class="col-xs-12 col-lg-6">
                    <div class="shopkit-auth-form-register-info">
                        <div class="login-register-title">
                            <h2 class="title margin-bottom-lg text-center">{{ 'lang.storefront.signin.no_account.text'|t }}<br>{{ 'lang.storefront.signin.no_account.signup'|t }}</h2>
                            <ul class="margin-bottom-lg list-unstyled text-left">
                                <li class="d-inline-flex margin-bottom-sm"><i class="fa fa-check text-primary text-h4 margin-right-xs"></i>{{ 'lang.storefront.signin.no_account.orders.text'|t }}</li>
                                <li class="d-inline-flex margin-bottom-sm"><i class="fa fa-check text-primary text-h4 margin-right-xs"></i>{{ 'lang.storefront.signin.no_account.wishlist.text'|t }}</li>
                                <li class="d-inline-flex"><i class="fa fa-check text-primary text-h4 margin-right-xs"></i>{{ 'lang.storefront.signin.no_account.address.text'|t }}</li>
                            </ul>
                            <div class="text-center">
                                <a href="{{ site_url('signup') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-lg">{{ 'lang.storefront.login.signup.create_account.button'|t }}</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{% endblock %}