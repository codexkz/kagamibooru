<p><%= ctx.t('help.searchGeneral.intro') %></p>

<table>
    <thead>
        <tr>
            <th><%= ctx.t('help.searchGeneral.syntax') %></th>
            <th><%= ctx.t('help.searchGeneral.tokenType') %></th>
            <th><%= ctx.t('help.searchGeneral.description') %></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td><code>&lt;value&gt;</code></td>
            <td><%= ctx.t('help.searchGeneral.anonymous') %></td>
            <td><%= ctx.t('help.searchGeneral.anonymousDesc') %></td>
        </tr>
        <tr>
            <td><code>&lt;key&gt;:&lt;value&gt;</code></td>
            <td><%= ctx.t('help.searchGeneral.named') %></td>
            <td><%= ctx.t('help.searchGeneral.namedDesc') %></td>
        </tr>
        <tr>
            <td><code>sort:&lt;style&gt;</code></td>
            <td><%= ctx.t('help.searchGeneral.sortStyle') %></td>
            <td><%= ctx.t('help.searchGeneral.sortStyleDesc') %></td>
        </tr>
        <tr>
            <td><code>special:&lt;value&gt;</code></td>
            <td><%= ctx.t('help.searchGeneral.special') %></td>
            <td><%= ctx.t('help.searchGeneral.specialDesc') %></td>
        </tr>
    </tbody>
</table>

<p><%= ctx.t('help.searchGeneral.ranged') %></p>

<table>
    <tbody>
        <tr>
            <td><code>a,b,c</code></td>
            <td><%= ctx.t('help.searchGeneral.composite').replace('{a}', 'a').replace('{b}', 'b').replace('{c}', 'c') %></td>
        </tr>
        <tr>
            <td><code>1..</code></td>
            <td><%= ctx.t('help.searchGeneral.gte') %></td>
        </tr>
        <tr>
            <td><code>..4</code></td>
            <td><%= ctx.t('help.searchGeneral.lte') %></td>
        </tr>
        <tr>
            <td><code>1..4</code></td>
            <td><%= ctx.t('help.searchGeneral.range') %></td>
        </tr>
    </tbody>
</table>

<p><%= ctx.t('help.searchGeneral.minMax').replace('{min}', '-min').replace('{max}', '-max').replace('{example}', 'score-min:1') %></p>

<p><%= ctx.t('help.searchGeneral.dateTime') %></p>

<ul>
    <li><code>today</code></li>
    <li><code>yesterday</code></li>
    <li><code>&lt;year&gt;</code></li>
    <li><code>&lt;year&gt;-&lt;month&gt;</code></li>
    <li><code>&lt;year&gt;-&lt;month&gt;-&lt;day&gt;</code></li>
</ul>

<p><%= ctx.t('help.searchGeneral.wildcards').replace('{wildcard}', '*') %></p>

<p><%= ctx.t('help.searchGeneral.negate').replace('{dash}', '-') %></p>

<p><%= ctx.t('help.searchGeneral.sortDirection').replace('{asc}', ',asc').replace('{desc}', ',desc') %></p>

<p><%= ctx.t('help.searchGeneral.escape').replace('{colon}', ':').replace('{dash}', '-').replace('{backslash}', '\\\\') %></p>

<h1><%= ctx.t('help.searchGeneral.example') %></h1>

<p><%= ctx.t('help.searchGeneral.exampleIntro') %></p>

<pre><code>sea -fav-count:8.. type:swf uploader:Pirate</code></pre>

<p><%= ctx.t('help.searchGeneral.exampleDesc') %></p>

<p><%= ctx.t('help.searchGeneral.exampleError').replace('{query1}', 're:zero') %></p>

<p><%= ctx.t('help.searchGeneral.exampleEscape').replace('{query2}', 're\\:zero').replace('{tag}', 're:zero') %></p>
