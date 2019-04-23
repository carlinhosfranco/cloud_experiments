# Evaluate Cloud Computing Overcommitment

Os Scripts foram implementados para automatizar a execução dos testes em ambiente de nuvem *overcommitment*. O cenário de testes trabalha de maneira similar à uma aplicação mestre-escravo, onde existe um mestre que coordena os trabalhos e os escravos que realizam a computação.

O *script* ```main_exe.sh``` controla todo o ambiente de execução. Ele deve ser executado em uma instância para que o desempenho da aplicação seja coletado. Este *script* controla a execução das aplicações nas outras instâncias do ambiente de nuvem. A medida que outras instâncias executam aplicações de difrentes tipos da instância principal, o ambiente *overcommitment* é gerado, onde existe uma concorrência de recursos por todas as instâncias.
