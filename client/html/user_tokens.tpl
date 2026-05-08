<div id='user-tokens'>
    <div class='messages'></div>
    <% if (ctx.tokens.length > 0) { %>
    <div class='token-flex-container'>
        <% _.each(ctx.tokens, function(token, index) { %>
        <div class='token-flex-row'>
            <div class='token-flex-column token-flex-labels'>
                <div class='token-flex-row'><%= ctx.t('userTokens.token') %></div>
                <div class='token-flex-row'><%= ctx.t('userTokens.note') %></div>
                <div class='token-flex-row'><%= ctx.t('userTokens.created') %></div>
                <div class='token-flex-row'><%= ctx.t('userTokens.expires') %></div>
                <div class='token-flex-row no-wrap'><%= ctx.t('userTokens.lastUsed') %></div>
            </div>
            <div class='token-flex-column full-width'>
                <div class='token-flex-row'><%= token.token %></div>
                <div class='token-flex-row'>
                    <% if (token.note !== null) { %>
                        <%= token.note %>
                    <% } else { %>
                        <%= ctx.t('userTokens.noNote') %>
                    <% } %>
                    <a class='token-change-note' data-token-id='<%= index %>' href='#'>(<%= ctx.t('userTokens.change') %>)</a>
                </div>
                <div class='token-flex-row'><%= ctx.makeRelativeTime(token.creationTime) %></div>
                <div class='token-flex-row'>
                    <% if (token.expirationTime) { %>
                        <%= ctx.makeRelativeTime(token.expirationTime) %>
                    <% } else { %>
                        <%= ctx.t('userTokens.noExpiration') %>
                    <% } %>
                </div>
                <div class='token-flex-row'><%= ctx.makeRelativeTime(token.lastUsageTime) %></div>
            </div>
        </div>
        <div class='token-flex-row'>
            <div class='token-flex-column full-width'>
                <div class='token-flex-row'>
                    <form class='token' data-token-id='<%= index %>'>
                        <% if (token.isCurrentAuthToken) { %>
                            <input type='submit' value='<%= ctx.t("userTokens.deleteAndLogout") %>'
                                title='<%= ctx.t("userTokens.deleteAndLogoutHint") %>'/>
                        <% } else { %>
                            <input type='submit' value='<%= ctx.t("userTokens.delete") %>'/>
                        <% } %>
                    </form>
                </div>
            </div>
        </div>
        <hr/>
        <% }); %>
    </div>
    <% } else { %>
        <h2><%= ctx.t('userTokens.noTokens') %></h2>
    <% } %>
    <form id='create-token-form'>
        <ul class='input'>
            <li class='note'>
                <%= ctx.makeTextInput({
                    text: ctx.t('userTokens.noteLabel'),
                    id: 'note',
                }) %>
            </li>
            <li class='expirationTime'>
                <%= ctx.makeDateInput({
                    text: ctx.t('userTokens.expiresLabel'),
                    id: 'expirationTime',
                }) %>
            </li>
        </ul>
        <div class='buttons'>
            <input type='submit' value='<%= ctx.t("userTokens.createToken") %>'/>
        </div>
    </form>
</div>
