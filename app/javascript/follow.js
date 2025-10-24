const btn = document.getElementById('unfollow-button');
  const csrfToken = document.querySelector('meta[name="csrf-token"]').content;

  btn.addEventListener('click', () => {
      let btnText = btn.textContent === 'Unfollow' ? 'unfollow_user' : 'follow_user';
      fetch(`/${document.querySelector('h3').textContent}/${btnText}`, {
        method: "POST",
        headers: {
          'X-CSRF-Token': csrfToken
        }
        })
      .then(r => r.json())
      .then(d => {
        console.log(d);
        btn.classList.toggle('btn-primary');
        btn.classList.toggle('btn-danger');
        document.getElementById('followers').textContent = d.count === 1 ? `${d.count} follower` : `${d.count ? d.count : 0} followers` 
        btn.textContent = btn.textContent === 'Unfollow' ? 'Follow' : 'Unfollow';
      })
      .catch(e => alert(e));
    });