{#
Description: Rewards account page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb well-default">
        <li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
        <li><a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a><span class="divider">›</span></li>
        <li class="active">{{ rewards_label }}</li>
    </ul>

    <h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

    <br>

    <div class="row-fluid">
        <div class="span12">

            <h3 class="margin-top-0 text-gray light">{{ rewards_label }}</h3>

            <div class="margin-bottom">
                <h4>{{ 'lang.storefront.account.rewards.available.text'|t }} <strong class="text-underline">{{ user.rewards|rewards_label }}</strong></h4>
                {{ store.settings.rewards.page ? '<p><a href="'~ store.settings.rewards.page.url ~'">Saber mais</a></p>' : '' }}
            </div>

            <h3 class="margin-top-0 text-gray light">{{ 'lang.storefront.account.rewards.history'|t }}</h3>

            {% if user.rewards_history %}
                <div class="table-responsive">
                    <table class="table well-featured table-hover table-striped table-hover">
                        <thead>
                            <tr>
                                <th>{{ 'lang.storefront.account.rewards.type'|t }}</th>
                                <th>{{ 'lang.storefront.account.rewards.date'|t }}</th>
                                <th>{{ 'lang.storefront.account.rewards.expire_at'|t }}</th>
                                <th>{{ 'lang.storefront.account.rewards.description'|t }}</th>
                                <th class="text-center">{{ 'lang.storefront.account.rewards.points'|t }}</th>
                                <th class="text-center">{{ 'lang.storefront.account.rewards.balance'|t }}</th>
                            </tr>
                        </thead>
                        <tbody>
                            {% for entry in user.rewards_history %}
                                <tr>
                                    <td>{{ entry.event}}</td>
                                    <td class="text-nowrap">{{ entry.date|format_datetime('long','none') }}</td>
                                    <td class="text-nowrap">{{ entry.expire_at ? entry.expire_at|format_datetime('long','none') : '' }}</td>
                                    <td>{{ entry.description }}</td>
                                    <td class="text-center">{{ entry.points <= 0 ? entry.points : '+' ~ entry.points }}</td>
                                    <td class="text-center">{{ entry.balance }}</td>
                                </tr>
                            {% endfor %}
                        </tbody>
                    </table>
                </div>
            {% else %}
                <p>{{ 'lang.storefront.account.rewards.no_history'|t }}</p>
            {% endif %}

        </div>
    </div>

{% endblock %}