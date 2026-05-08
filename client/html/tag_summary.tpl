<div class='content-wrapper tag-summary'>
    <section class='details'>
        <section>
            <% if (ctx.tag.categories && ctx.tag.categories.length > 0) { %>
                <%= ctx.t('tagSummary.categories') %>
                <% for (let cat of ctx.tag.categories) { %>
                    <span class='<%= ctx.makeCssName(cat, 'tag') %>'><%- cat %></span>
                <% } %>
            <% } else if (ctx.tag.category) { %>
                <%= ctx.t('tagSummary.category') %>
                <span class='<%= ctx.makeCssName(ctx.tag.category, 'tag') %>'><%- ctx.tag.category %></span>
            <% } %>
        </section>

        <section>
        <%= ctx.t('tagSummary.aliases') %><br/>
        <ul><!--
            --><% for (let name of ctx.tag.names.slice(1)) { %><!--
                --><li><%= ctx.makeTagLink(name, false, false, ctx.tag) %></li><!--
            --><% } %><!--
        --></ul>
        </section>

        <section>
        <%= ctx.t('tagSummary.implications') %><br/>
        <ul><!--
            --><% for (let tag of ctx.tag.implications) { %><!--
                --><li><%= ctx.makeTagLink(tag.names[0], false, false, tag) %></li><!--
            --><% } %><!--
        --></ul>
        </section>

        <section>
        <%= ctx.t('tagSummary.suggestions') %><br/>
        <ul><!--
            --><% for (let tag of ctx.tag.suggestions) { %><!--
                --><li><%= ctx.makeTagLink(tag.names[0], false, false, tag) %></li><!--
            --><% } %><!--
        --></ul>
        </section>
    </section>

    <section class='description'>
        <hr/>
        <%= ctx.makeMarkdown(ctx.tag.description || ctx.t('tagSummary.noDescription')) %>
        <p>This tag has <a href='<%- ctx.formatClientLink('posts', {query: ctx.escapeTagName(ctx.tag.names[0])}) %>'><%- ctx.tag.postCount %> <%= ctx.t('tagSummary.usages') %></a>.</p>
    </section>
</div>
