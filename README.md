<p align="center">
    <h1 align="center">
        Luniverse NOVA Tester Program
    </h1>
    <p align="center">Using Node Provider, Multichain APIs</p>
</p>

## 1. reference

|                 | Luniverse NOVA                          | Alchemy                                                                              |
| --------------- | --------------------------------------- | ------------------------------------------------------------------------------------ |
| Homepage        | [link](https://luniverse.io/)           | [link](https://www.alchemy.com/)                                                     |
| Service console | [link](https://console.luniverse.io/)   | [link](https://auth.alchemy.com/?redirectUrl=https%3A%2F%2Fdashboard.alchemy.com%2F) |
| developer docs  | [link](https://developer.luniverse.io/) | [link](https://docs.alchemy.com/)                                                    |

---

## 2. testing contract

```bash
$ npx hardhat test test/Lock.ts
```

## 3. environment variables

```env
LUNIVERSE_MUMBAI_API_KEY=
ALCHEMY_SEPOLIA_API_KEY=
PRIVATE_KEY=
```

## 4. deploying contract

- `scripts/` 폴더에 있는 파일 실행
- 로컬에 배포 후 테스트 하는 방법
  - `$ npx hardhat node`
  - `$ npx hardhat run scripts/deploy.ts`

```bash
# sepolia bscMainnet bscTestnet
$ npx hardhat run scripts/deploy.ts --network mumbai
```

[//]: # (---)

[//]: # (## 5. Web3 Engine - Multichain API TEST)

[//]: # (| [Account&#40;Wallet&#41;]&#40;https://developer.luniverse.io/reference/account&#41; | HTTP 메서드 | 성공 여부 | 날짜     |)

[//]: # (|---------------------------------------------------------------------|----------|-------|--------|)

[//]: # (| listAccountBalance                                                  | GET      | 미성공   | 230812 |)

[//]: # (| listMultiAccountsBalance                                                  | POST     | 미성공   | 230812 |)

[//]: # (| listAccountTransactions                                                  | GET      | 미성공   | 230812 |)

[//]: # ()
[//]: # (---)

[//]: # ()
[//]: # (| [Block/Transaction]&#40;https://developer.luniverse.io/reference/blocktransaction&#41; | HTTP 메서드 | 성공 여부 | 날짜     |)

[//]: # (|---------------------------------------------------------------------|----------|-------|--------|)

[//]: # (| getGasPrice                                                  | GET      | 미성공   | 230812 |)

[//]: # ()
[//]: # ()
[//]: # (---)