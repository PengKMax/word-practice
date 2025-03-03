<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>单词拼读练习</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f5f7;
            display: flex;
            flex-direction: column;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 40px;
        }

        .container {
            background: white;
            border-radius: 18px;
            padding: 40px;
            width: 800px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .word {
            font-family: Arial;
            font-size: 72px;
            text-align: center;
            cursor: pointer;
            margin: 20px 0;
        }

        .phonetic {
            font-family: 'Times New Roman';
            font-size: 32px;
            text-align: center;
            color: #666;
            margin: 10px 0;
        }

        .meaning {
            font-family: '微软雅黑';
            font-size: 32px;
            text-align: center;
            color: #333;
            margin: 20px 0 40px;
        }

        .syllable-container {
            background: #f5f5f7;
            border-radius: 18px;
            padding: 30px;
            margin: 20px 0;
        }

        .line {
            border-bottom: 3px solid #007AFF;
            margin-bottom: 30px;
            height: 60px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }

        .syllables {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            justify-content: center;
        }

        .syllable {
            background: white;
            border-radius: 10px;
            padding: 12px 24px;
            font-family: Arial;
            font-size: 36px;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            transition: all 0.2s;
        }

        .syllable:hover {
            transform: translateY(-2px);
        }

        button {
            background: #007AFF;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 25px;
            font-size: 20px;
            cursor: pointer;
            margin: 30px auto;
            display: block;
            transition: all 0.2s;
        }

        button:hover {
            background: #0063CC;
            transform: scale(1.05);
        }

        .vowel { color: #FF3B30; }
        .consonant { color: #007AFF; }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="word" onclick="toggleSyllables()"></div>
        <div class="phonetic"></div>
        <div class="meaning"></div>
        <div class="syllable-container">
            <div class="line"></div>
            <div class="syllables"></div>
        </div>
        <button onclick="nextWord()">下一页</button>
    </div>

    <script>
        const words = [
            {word: 'family', phonetic: '/fæmɪli/', meaning: '家庭', syllables: ['fam', 'i', 'ly']},
            {word: 'house', phonetic: '/haʊs/', meaning: '房子', syllables: ['h', 'ouse']},
            {word: 'home', phonetic: '/hoʊm/', meaning: '家', syllables: ['h', 'ome']},
            {word: 'kitchen', phonetic: '/ˈkɪtʃən/', meaning: '厨房', syllables: ['kitch', 'en']},
            {word: 'bedroom', phonetic: '/ˈbedruːm/', meaning: '卧室', syllables: ['bed', 'room']},
            {word: 'living room', phonetic: '/ˈlɪvɪŋ ruːm/', meaning: '客厅', syllables: ['liv', 'ing', 'room']},
            {word: 'bathroom', phonetic: '/ˈbæθruːm/', meaning: '浴室', syllables: ['bath', 'room']},
            {word: 'sofa', phonetic: '/ˈsəʊfə/', meaning: '沙发', syllables: ['so', 'fa']},
            {word: 'chair', phonetic: '/tʃɛər/', meaning: '椅子', syllables: ['ch', 'air']},
            {word: 'table', phonetic: '/teɪbl/', meaning: '桌子', syllables: ['ta', 'ble']},
            {word: 'window', phonetic: '/ˈwɪndoʊ/', meaning: '窗户', syllables: ['win', 'dow']},
            {word: 'door', phonetic: '/dɔr/', meaning: '门', syllables: ['d', 'oor']},
            {word: 'champion', phonetic: '[ˈtʃæmpiən]', meaning: '冠军', syllables: ['cham', 'pi', 'on']},
            {word: 'university', phonetic: '[ˌjuːnɪˈvɜːsəti]', meaning: '大学', syllables: ['u', 'ni', 'ver', 'si', 'ty']},
            {word: 'dictionary', phonetic: '[ˈdɪkʃənri]', meaning: '词典', syllables: ['dic', 'tion', 'ary']},
            {word: 'television', phonetic: '[ˈtelɪvɪʒn]', meaning: '电视', syllables: ['tele', 'vi', 'sion']},
            {word: 'important', phonetic: '[ɪmˈpɔːtnt]', meaning: '重要的', syllables: ['im', 'por', 'tant']},
            {word: 'beautiful', phonetic: '[ˈbjuːtɪfl]', meaning: '美丽的', syllables: ['beau', 'ti', 'ful']},
            {word: 'delicious', phonetic: '[dɪˈlɪʃəs]', meaning: '美味的', syllables: ['de', 'li', 'cious']},
            {word: 'vegetable', phonetic: '[ˈvedʒtəbl]', meaning: '蔬菜', syllables: ['veg', 'e', 'ta', 'ble']},
            {word: 'recommendation', phonetic: '[ˌrekəmenˈdeɪʃn]', meaning: '推荐', syllables: ['re', 'com', 'men', 'da', 'tion']},
            {word: 'unbelievable', phonetic: '[ˌʌnbɪˈliːvəbl]', meaning: '难以置信的', syllables: ['un', 'be', 'liev', 'a', 'ble']},
            {word: 'disappointment', phonetic: '[ˌdɪsəˈpɔɪntmənt]', meaning: '失望', syllables: ['dis', 'ap', 'point', 'ment']},
            {word: 'responsibility', phonetic: '[rɪˌspɒnsəˈbɪləti]', meaning: '责任', syllables: ['re', 'spon', 'si', 'bil', 'i', 'ty']},
            {word: 'entertainment', phonetic: '[ˌentəˈteɪnmənt]', meaning: '娱乐', syllables: ['en', 'ter', 'tain', 'ment']},
            {word: 'temperature', phonetic: '[ˈtemprətʃə(r)]', meaning: '温度', syllables: ['tem', 'per', 'a', 'ture']},
            {word: 'communication', phonetic: '[kəˌmjuːnɪˈkeɪʃn]', meaning: '表达', syllables: ['com', 'mu', 'ni', 'ca', 'tion']},
            {word: 'celebration', phonetic: '[ˌselɪˈbreɪʃn]', meaning: '庆祝活动', syllables: ['ce', 'le', 'bra', 'tion']}
        ];

        let currentWord = 0;
        let selectedSyllables = [];
        let originalWord = '';

        function init() {
            const word = words[currentWord];
            document.querySelector('.word').textContent = word.word;
            document.querySelector('.phonetic').textContent = word.phonetic;
            document.querySelector('.meaning').textContent = word.meaning;
            originalWord = word.word.replace(/ /g, '');
            
            const syllables = shuffle([...word.syllables]);
            document.querySelector('.syllables').innerHTML = syllables
                .map(s => `<div class="syllable" onclick="moveSyllable(this)">${s}</div>`)
                .join('');
            
            document.querySelector('.line').innerHTML = '';
            selectedSyllables = [];
        }

        function shuffle(array) {
            return array.sort(() => Math.random() - 0.5);
        }

        function toggleSyllables() {
            const wordElement = document.querySelector('.word');
            if (wordElement.classList.contains('syllables-split')) {
                wordElement.innerHTML = words[currentWord].word;
                wordElement.classList.remove('syllables-split');
            } else {
                const syllables = words[currentWord].syllables.join('').split(/([aeiouy]+)/i)
                    .filter(s => s)
                    .map(s => {
                        const isVowel = /[aeiouy]/i.test(s);
                        return `<span class="${isVowel ? 'vowel' : 'consonant'}">${s}</span>`;
                    });
                wordElement.innerHTML = syllables.join('');
                wordElement.classList.add('syllables-split');
            }
        }

        function moveSyllable(element) {
            const line = document.querySelector('.line');
            if (element.parentElement === line) {
                element.remove();
                document.querySelector('.syllables').appendChild(element);
            } else {
                line.appendChild(element.cloneNode(true));
                element.remove();
            }
            checkSpelling();
        }

        function checkSpelling() {
            const lineText = [...document.querySelectorAll('.line .syllable')]
                .map(el => el.textContent)
                .join('')
                .replace(/ /g, '');
            
            if (lineText === originalWord) {
                document.querySelector('.syllables').innerHTML = '';
                document.querySelector('.line').innerHTML = 
                    `<div class="word" style="font-size:72px;color:#007AFF">${originalWord}</div>`;
            } else if (lineText.length === originalWord.length && lineText !== originalWord) {
                document.querySelectorAll('.line .syllable').forEach(el => {
                    el.style.animation = 'blink 0.5s 3';
                    setTimeout(() => el.style.animation = '', 1500);
                });
                setTimeout(() => {
                    document.querySelector('.line').innerHTML = '';
                    init();
                }, 1500);
            }
        }

        function nextWord() {
            currentWord = (currentWord + 1) % words.length;
            init();
        }

        // 初始化第一个单词
        init();
    </script>
</body>
</html>
