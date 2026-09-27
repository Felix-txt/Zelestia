<script>
    let {
        csrf_token,
        children, 
        ...props
        } = $props();
</script>

<form {...props}>
    <input type="hidden" name="_csrf_token" value={csrf_token} />
    <br>
    {#if children}
        {@render children()}
    {/if}
</form>

<style>
    form{
        background-color: rgb(120, 79, 191);
        box-shadow: 4px 4px rgb(88, 48, 157);
        padding: 64px;
        width: 600px;
        height: 400px;
        border-radius: 64px;
    }
</style>