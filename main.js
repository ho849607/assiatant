
class LottoMachine extends HTMLElement {
  constructor() {
    super();
    const shadow = this.attachShadow({ mode: 'open' });

    const template = document.createElement('template');
    template.innerHTML = `
      <style>
        :host {
          display: block;
          text-align: center;
        }

        .card {
          background-color: white;
          padding: 2rem;
          border-radius: 16px;
          box-shadow: 0 8px 32px oklch(0.6 0.15 260 / 0.2);
        }

        h1 {
          font-family: var(--font-title);
          color: var(--accent-color);
          font-size: 2.5rem;
          margin-bottom: 1rem;
        }

        .numbers {
          display: flex;
          justify-content: center;
          gap: 1rem;
          margin: 2rem 0;
        }

        .number {
          width: 50px;
          height: 50px;
          display: grid;
          place-content: center;
          border-radius: 50%;
          background-color: var(--accent-color);
          color: white;
          font-size: 1.5rem;
          font-weight: bold;
          box-shadow: 0 4px 8px oklch(0.6 0.15 260 / 0.3);
        }

        button {
          font-family: var(--font-body);
          font-size: 1.2rem;
          font-weight: bold;
          background-color: var(--accent-color);
          color: white;
          border: none;
          padding: 0.8rem 2rem;
          border-radius: 8px;
          cursor: pointer;
          transition: transform 0.2s, box-shadow 0.2s;
        }

        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px oklch(0.6 0.15 260 / 0.4);
        }

        button:active {
            transform: translateY(0);
            box-shadow: 0 4px 8px oklch(0.6 0.15 260 / 0.3);
        }
      </style>

      <div class="card">
        <h1>Lotto Machine</h1>
        <p>Click the button to get your lucky numbers!</p>
        <div class="numbers"></div>
        <button>Generate Numbers</button>
      </div>
    `;

    shadow.appendChild(template.content.cloneNode(true));

    this.numbersContainer = shadow.querySelector('.numbers');
    this.generateButton = shadow.querySelector('button');

    this.generateButton.addEventListener('click', () => this.generateNumbers());
    this.generateNumbers();
  }

  generateNumbers() {
    const numbers = new Set();
    while (numbers.size < 6) {
      const randomNumber = Math.floor(Math.random() * 45) + 1;
      numbers.add(randomNumber);
    }

    const sortedNumbers = Array.from(numbers).sort((a, b) => a - b);
    this.renderNumbers(sortedNumbers);
  }

  renderNumbers(numbers) {
    this.numbersContainer.innerHTML = '';
    for (const number of numbers) {
      const numberElement = document.createElement('div');
      numberElement.classList.add('number');
      numberElement.textContent = number;
      this.numbersContainer.appendChild(numberElement);
    }
  }
}

customElements.define('lotto-machine', LottoMachine);
