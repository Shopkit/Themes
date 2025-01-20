{#
Description: Contact Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ store.page.contact.title }}</li>
            </ul>
        </div>
    </div>

    <div class="contacts section">
        <div class="contacts-details">
            <div class="{{ layout_container }}">
                <h2 class="contacts-title title">{{ store.page.contact.title }}</h2>

                {% if store.latitude and store.longitude %}
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="contacts-map margin-bottom">
                                <iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>
                            </div>
                        </div>
                    </div>
                {% endif %}

                <div class="row">
                    <div class="contact-address col-lg-12 text-center margin-bottom">
                        <address>
                            {% if store.address %}
                                {{ line_break(store.address) }}
                            {% endif %}
                        </address>
                        <phone>
                            {% if store.phone %}
                                <a href="tel:{{ store.phone }}">{{ store.phone }}</a>
                            {% endif %}
                        </phone>
                        <phone>
                            {% if store.cellphone %}
                                <a href="tel:{{ store.cellphone }}">{{ store.cellphone }}</a>
                            {% endif %}
                        </phone>
                        {% if store.show_email %}
                            {{ safe_mailto(store.email) }}
                        {% endif %}
                    </div>
                </div>

                {% if store.page.contact.content %}
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="contacts-text">{{ store.page.contact.content }}</div>
                        </div>
                    </div>
                {% endif %}


            </div>
        </div>

        <div class="contacts-container">
            <div class="{{ layout_container }}">
                <div class="row">
                    <div class="col-lg-6">
                        <div class="contacts-wrap">
                            <h2 class="contacts__title title">{{ 'lang.storefront.contact.contact_form.title'|t }}</h2>
                        </div>
                    </div>

                    <div class="col-lg-6">
                        {{ form_open('contact_form', { 'class' : 'contact-form contacts-form', 'id' : 'contact-form' }) }}

                            <div class="form-group">
                                <label for="name">{{ 'lang.storefront.form.name.label'|t }}</label>
                                <input class="form-control" type="text" name="name" id="name" value="{{ store.page.contact.form.name|default(user.name) }}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">{{ 'lang.storefront.form.email.label'|t }}</label>
                                <input class="form-control" type="email" name="email" id="email" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" value="{{ store.page.contact.form.email|default(user.email) }}" required>
                            </div>
                            <div class="form-group">
                                <label for="subject">{{ 'lang.storefront.form.subject.label'|t }}</label>
                                <input class="form-control" type="text" name="subject" id="subject" placeholder="{{ 'lang.storefront.form.subject.placeholder'|t }}" value="{{ store.page.contact.form.subject|default(get.p) }}" required>
                            </div>
                            <div class="form-group">
                                <label for="message">{{ 'lang.storefront.form.message.label'|t }}</label>
                                <textarea class="form-control" name="message" id="message" rows="10" required>{% if not events.contact_form_success %}{{ get.p ? 'lang.storefront.contact.contact_form.message.default'|t([get.p]) }}{% endif %}</textarea>
                            </div>

                            {% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
                                <div class="accept_terms checkbox">
                                    <label>
                                        <input type="checkbox" name="accept_terms" id="accept_terms" value="1" required>

                                        {% if store.settings.cart.page_terms and store.settings.cart.page_privacy %}
                                            {{ 'lang.storefront.cart.terms_privacy'|t([store.settings.cart.page_terms.url, store.settings.cart.page_privacy.url]) }}
                                        {% elseif store.settings.cart.page_terms and not store.settings.cart.page_privacy %}
                                            {{ 'lang.storefront.cart.terms'|t([store.settings.cart.page_terms.url]) }}
                                        {% elseif store.settings.cart.page_privacy and not store.settings.cart.terms %}
                                            {{ 'lang.storefront.cart.privacy'|t([store.settings.cart.page_privacy.url]) }}
                                        {% endif %}
                                    </label>
                                </div>
                            {% endif %}

                            <div class="form-group">
                                <div class="g-recaptcha" id="g-recaptcha-contact"></div>
                            </div>

                            <button class="contacts-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" type="submit">{{ 'lang.storefront.form.message.button'|t }}</button>

                        {{ form_close() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    {% if apps.newsletter %}
        {{ generic_macros.newsletter_block() }}
    {% endif %}

{% endblock %}