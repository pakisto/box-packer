# ansible-packer

ansible-packer 프로젝트는 개발자 또는 운영자가 윈도우즈 로컬 환경에서 테스트, 운영에 필요한 머신 이미지, 도커 이미지를 쉽게 제작하기 위해 만들어졌다.

## 사전 준비

### 설치 프로그램
### Ansible packer VM 설정

## Ansible packer VM 기동
최초 프로젝트 홈 디렉토리에서 `vagrant up` 명령으로 Vagrant를 통해 로컬 환경에 이미지 생성을 돕는 ubuntu VM을 생성한다.
Ubuntu VM은 Hashicorp Packer와 Ansible 이 기본적으로 설치되어 있다.
```
> vagrant up
```

## Ansible packer VM SSH 접속
사용자는 `vagrant ssh` 명령을 통해 해당 환경에 접근할 수 있으며, packer 명령을 통해 다양한 이미지를 만들 수 있다.
```
> vagrant ssh
```

## 이미지 생성
아래는 jenkins가 설치된 AMI 이미지를 생성하는 명령 예제이다. 
```
$ packer build packer.ami.jenkins.json
```

위 명령을 수행하면, 자신의 AWS 계정에 jenkins가 설치된 ubuntu AMI가 생성된다.

> 주의. 이 프로젝트에서 생성되는 이미지는 최종 애플리케이션 이미지를 만드는게 목적이 아니라 펀더먼탈 이미지를 생성하는데 목적을 두고 있다. 

## Packer 설정 파일 작명 규칙
packer 설정 파일은 위 명령 예제에서 보이는 것 처럼 `pakcer.<target platform>.<main application>.json` 형태의 이름을 가진다.

> 참고. 현재 제공되는 packer 설정은 ami jenkins 만 존재하는데, 프로젝트 개념을 증명하기 위한 것으로 추후 필요한 설정을 추가할 예정이다.

> 주의. 만들어진 packer 설정과 ansible 코드는 CI/CD 툴에서 이미지 생성 프로세스에 재사용이 가능하도록 제작할 예정이다.

## Ansible 사용

애플리케이션 설치는 ansible을 통해서 이루어진다.
Packer는 ansible 이외에도 shell, file 과 같은 다양한 provisioner를 사용할 수 있지만 기본으로 ansible provisioner를 사용하도록 제한한다.
Ansible은 애플리케이션 설치 스크립트를 코드화해서 관리하기 용이하며 이미 제공되고 있는 ansible role 을 사용할 수 있다. 





