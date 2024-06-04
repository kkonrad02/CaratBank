const signIn = () => {
    document.getElementById("modal_background").style.display = "block";
    document.getElementById("modal").style.display = "block";
    window.location.href = "/auth/addConfirmation";
}