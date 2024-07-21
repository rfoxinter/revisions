async function hamburger() {
    var response = await fetch('https://rfoxinter.github.io/revisions/hamburger.txt');
    if (response.status == 200) {
        const jsCode = await response.text();
        const ul = document.getElementById('hamburger');
        var array = jsCode.split('\n');
        const url = document.location.href.replace('index.html', '');
        for (let i = 0; i < array.length/2; ++i) {
            if (array[2 * i + 1] == url) {
                let li = document.createElement('li');
                let b = document.createElement('b');
                b.style.color = '#606c71';
                b.innerHTML = array[2 *i];
                li.appendChild(b);
                ul.appendChild(li);
            } else {
                let li = document.createElement('li');
                let a = document.createElement('a');
                a.setAttribute('href', array[2 * i + 1]);
                a.innerHTML = array[2 *i];
                li.appendChild(a);
                ul.appendChild(li);
            }
        }
    }
}