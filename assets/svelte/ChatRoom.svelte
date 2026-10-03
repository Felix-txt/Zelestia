<script>
    import {preventDefault} from "svelte/legacy"

    import {slide} from "svelte/transition"

    /** @type {{messages: any, live: any}} */
    let {messages, live} = $props()

    let message = $state("")

    function submitMessage() {
        if (message === "") return
        live.pushEvent("send_message", {body: message})
        message = ""
    }
    function handleKeydown(event) {
    if (event.key === 'Enter') {
      if (event.shiftKey) {
        // Standard behaivour
        return;
      } else {
        // Submit
        event.preventDefault();
        submitMessage();
      }
    }
  }
</script>

<div class="field">
    <ul class="messages">
        {#each messages as message (message.id)}
            <li in:slide id="{message.id}">
                <i>{message.name}:</i>
                <br>
                <div class="markdown-preview">{@html message.body}</div>
            </li>
        {/each}
    </ul>

    <form class="message_field" onsubmit={preventDefault(submitMessage)}>
        <textarea onkeydown={handleKeydown} type="text" name="message" class="rounded" bind:value={message} placeholder="Message..." autocomplete="off"></textarea>
        <button class="rounded">Send</button>  
    </form>
</div>

<style>
/* So markdown dose not go crazy with spacing */
.markdown-preview :global(h1),
.markdown-preview :global(h2),
.markdown-preview :global(h3) {
    margin-top: 0px;
    margin-bottom: 4px;
}

.markdown-preview :global(p) {
    margin-top: 0px;
    margin-bottom: 0px;
    white-space: pre-line; 
}

.field{
    display: flex;
    height: 100%;
    flex-direction: column;
    
    overflow: hidden;
    scroll-behavior: none;
}

.message_field{
    display: grid;
    grid-template-columns: 90% 10%;
    justify-content: center;
    max-height: 30px;
    border: 8px solid var(--theme-border);
    border-radius: 25px;
    background: var(--theme-middle-background);
    margin-bottom: 16px;
    margin-left: 16px;
    margin-right: 16px;
}

.messages{
    height: 800px;
    overflow: scroll;
    scroll-behavior: smooth;
}

.messages > li{
    word-wrap: break-word;
    list-style-type: none;
    font-weight: bold;
    font-size: large;
    color: var(--theme-foreground);
}

.rounded{
    word-wrap: break-word;
    background: var(--theme-border); /* input background */
    color: var(--theme-accent);/* text colour */
    border: none;
}

.message_field > button:hover{
    cursor: pointer;
}
</style>