<div class='content-wrapper pool-summary'>
    <section class='details'>
        <section>
            <%= ctx.t('poolSummary.category') %>
            <span class='<%= ctx.makeCssName(ctx.pool.category, 'pool') %>'><%- ctx.pool.category %></span>
        </section>

        <section>
        <%= ctx.t('poolSummary.aliases') %><br/>
        <ul><!--
            --><% for (let name of ctx.pool.names.slice(1)) { %><!--
                --><li><%= ctx.makePoolLink(ctx.pool.id, false, false, ctx.pool, name) %></li><!--
            --><% } %><!--
        --></ul>
        </section>
    </section>

    <section class='description'>
        <hr/>
        <%= ctx.makeMarkdown(ctx.pool.description || ctx.t('poolSummary.noDescription')) %>
        <p>This pool has <a href='<%- ctx.formatClientLink('posts', {query: 'pool:' + ctx.pool.id}) %>'><%- ctx.pool.postCount %> <%= ctx.t('poolSummary.posts') %></a>.</p>
    </section>
</div>
