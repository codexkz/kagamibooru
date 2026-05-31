<div id='user-tokens'>
    <div class='token-type-switch' style='display:flex; margin-bottom:1em;'>
        <a href data-type='web' style='padding:0.35em 1.2em; border:1px solid #24AADD; text-decoration:none; <%= ctx.tokenFilter !== "api" ? "background:#24AADD; color:#fff;" : "color:#24AADD;" %>'><%= ctx.t('userTokens.typeWeb') %></a><!--
        --><a href data-type='api' style='padding:0.35em 1.2em; border:1px solid #24AADD; border-left:0; text-decoration:none; <%= ctx.tokenFilter === "api" ? "background:#24AADD; color:#fff;" : "color:#24AADD;" %>'><%= ctx.t('userTokens.typeApi') %></a>
    </div>
    <div class='messages'></div>
    <% if (ctx.tokens.length > 0) { %>
    <% _.each(ctx.tokens, function(token, index) { %>
    <table class='token-table' style='width:100%; border-collapse:collapse; margin-bottom:0.5em; font-size:0.9em;'>
        <tbody>
            <% if (ctx.tokenFilter !== 'api') { %>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.type') %></td>
                <td style='padding:0.3em 0; vertical-align:top;'>
                    <span style='background:<%= token.type === "web" ? "#24AADD" : "#4CAF50" %>; font-size:0.8em; padding:0.1em 0.5em; color:#fff; display:inline-block;'>
                        <%= token.type %>
                    </span>
                </td>
            </tr>
            <% } %>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.tokenFilter === 'api' ? ctx.t('userTokens.apiKey') : ctx.t('userTokens.token') %></td>
                <td style='padding:0.3em 0; vertical-align:top; word-break:break-all; font-family:monospace; font-size:0.9em;'>
                    <% if (ctx.tokenFilter === 'api') { %>
                        <%= btoa(ctx.user.name + ':' + token.token) %>
                    <% } else { %>
                        <%= token.token %>
                    <% } %>
                </td>
            </tr>
            <% if (token.userAgent) { %>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.device') %></td>
                <td style='padding:0.3em 0; vertical-align:top; font-size:0.85em; color:#666;'><%= token.userAgent %></td>
            </tr>
            <% } %>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.note') %></td>
                <td style='padding:0.3em 0; vertical-align:top;'>
                    <% if (token.note !== null) { %>
                        <%= token.note %>
                    <% } else { %>
                        <%= ctx.t('userTokens.noNote') %>
                    <% } %>
                    <a class='token-change-note' data-token-id='<%= index %>' href='#'><%= ctx.t('userTokens.change') %></a>
                </td>
            </tr>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.created') %></td>
                <td style='padding:0.3em 0; vertical-align:top;'><%= ctx.makeRelativeTime(token.creationTime) %></td>
            </tr>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.expires') %></td>
                <td style='padding:0.3em 0; vertical-align:top;'>
                    <% if (token.expirationTime) { %>
                        <%= ctx.makeRelativeTime(token.expirationTime) %>
                    <% } else { %>
                        <%= ctx.t('userTokens.noExpiration') %>
                    <% } %>
                </td>
            </tr>
            <tr>
                <td style='white-space:nowrap; padding:0.3em 1em 0.3em 0; color:#888; vertical-align:top;'><%= ctx.t('userTokens.lastUsed') %></td>
                <td style='padding:0.3em 0; vertical-align:top;'><%= ctx.makeRelativeTime(token.lastUsageTime) %></td>
            </tr>
            <tr>
                <td colspan='2' style='padding:0.5em 0;'>
                    <form class='token' data-token-id='<%= index %>'>
                        <% if (token.isCurrentAuthToken) { %>
                            <input type='submit' value='<%= ctx.t("userTokens.deleteLogout") %>'
                                title='<%= ctx.t("userTokens.deleteLogoutHint") %>'/>
                        <% } else { %>
                            <input type='submit' value='<%= ctx.t("userTokens.delete") %>'/>
                        <% } %>
                    </form>
                </td>
            </tr>
        </tbody>
    </table>
    <hr/>
    <% }); %>
    <% } else { %>
        <h2><%= ctx.t('userTokens.noTokens') %></h2>
    <% } %>
    <form id='create-token-form' style='<%= ctx.tokenFilter === "api" ? "" : "display:none" %>'>
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
