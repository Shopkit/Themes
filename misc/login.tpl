{# Login Modal #}
    <div id="shopkit-auth">
        <div class="shopkit-auth-wrapper">
            <div class="shopkit-auth-modal">
                <a href="#" class="shopkit-auth-close-modal">&times;</a>
                <div class="shopkit-auth-errors"></div>
                <div class="shopkit-auth-success"></div>
                <div class="shopkit-auth-signup hidden">
                    <h2 class="shopkit-auth-signup-heading">Registo <span>ou <a href="#" data-toggle="replace" data-origin=".shopkit-auth-signup" data-target=".shopkit-auth-login">Login</a></span></h2>

                    {{ form_open(site_url('signup/post'), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-signup' }) }}
                        <div class="form-signup-fields">
                            <input type="text" name="shopkit-auth-name" class="shopkit-auth-name shopkit-auth-input" placeholder="O meu nome" required>
                            <input type="email" name="shopkit-auth-email" class="shopkit-auth-email shopkit-auth-input" placeholder="O meu e-mail" required>
                            <input type="password" name="shopkit-auth-password" class="shopkit-auth-password shopkit-auth-input" placeholder="A minha password" required>
                        </div>

                        {% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
                            <div class="shopkit-auth-footer">
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="shopkit-auth-accept-terms" id="shopkit-auth-accept-terms" value="1" required>
                                         Li e concordo com
                                         {% if store.settings.cart.page_terms %}
                                            os <a href="{{ store.settings.cart.page_terms.url }}" target="_blank">termos e condições</a>
                                         {% endif %}

                                         {% if store.settings.cart.page_terms and store.settings.cart.page_privacy %}e com{% endif %}

                                         {% if store.settings.cart.page_privacy %}
                                            a <a href="{{ store.settings.cart.page_privacy.url }}" target="_blank">política de privacidade</a>
                                         {% endif %}
                                    </label>
                                </div>
                            </div>
                        {% endif %}

                        <div class="shopkit-auth-btn-wrapper">
                            <button type="submit" class="shopkit-auth-btn-submit">Criar Conta</button>
                        </div>
                    {{ form_close() }}
                </div>
                <div class="shopkit-auth-login">
                    <h2 class="shopkit-auth-signup-heading">Login <span>ou <a href="#" data-toggle="replace" data-origin=".shopkit-auth-login" data-target=".shopkit-auth-signup">Registo</a></span></h2>

                    {{ form_open(site_url('signin/post') ~ (get.next ? '?next=' ~ get.next), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-login' }) }}
                        <input type="email" name="shopkit-auth-email" class="shopkit-auth-email shopkit-auth-input" placeholder="O meu e-mail">
                        <input type="password" name="shopkit-auth-password" class="shopkit-auth-password shopkit-auth-input" placeholder="A minha password">
                        <div class="shopkit-auth-footer">
                            <a href="#" class="shopkit-auth-link-new-account" data-toggle="replace" data-origin=".shopkit-auth-login" data-target=".shopkit-auth-signup">Criar nova conta</a> <a href="#" class="shopkit-auth-link-recover" data-toggle="replace" data-origin=".shopkit-auth-form-login" data-target=".shopkit-auth-form-recover">Recuperar password</a>
                        </div>
                        <div class="shopkit-auth-btn-wrapper">
                            <button type="submit" class="shopkit-auth-btn-submit">Entrar</button>
                        </div>
                    {{ form_close() }}

                    {{ form_open(site_url('signin/recover_password'), { 'method' : 'post', 'class' : 'shopkit-auth-form shopkit-auth-form-recover hidden' }) }}
                        <input type="email" name="shopkit-auth-email" class="shopkit-auth-email shopkit-auth-input" placeholder="O meu e-mail">
                        <div class="shopkit-auth-footer">
                            <a href="#" class="shopkit-auth-link-login" data-toggle="replace" data-origin=".shopkit-auth-form-recover" data-target=".shopkit-auth-form-login">Voltar para login</a>
                        </div>
                        <div class="shopkit-auth-btn-wrapper">
                            <button type="submit" class="shopkit-auth-btn-submit">Recuperar</button>
                        </div>
                    {{ form_close() }}
                </div>
            </div>
        </div>
    </div>
 {# End Login Modal #}