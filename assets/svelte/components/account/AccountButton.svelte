<script>
    let {type="submit", ...props} = $props();
</script>

<input type={type} {...props}>

<style>
    input{
        background-color: rgb(44, 94, 147);
        width: 120px;
        height: 32px;
        border-radius: 16px;
        color: white;
        font-weight: bold;
    }
</style>