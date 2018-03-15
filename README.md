# box-packer

## 개요
box-packer 는 hyper-v vagrant box 이미지를 제작하기 위한 프로젝트이다.

로컬에서 개발에 필요한 다양한 box 이미지를 생성할 수 있게 도와준다.

예를 들어 다음과 같은 이슈에 응용할 수 있다. 
* OpenShift 개발 환경을 로컬에 구성해 볼 수 있으며,
* Jenkins, Spinnaker 등 CI/CD 도구를 운용할 수 있는 이미지를 제작할 수 있다.
* 운영 환경과 유사한 배포 환경을 로컬에 구성해 볼 수 있다.

box-packer는 Hashicorp packer를 사용해 개발되었다.
주요 패키지 및 애플리케이션 설치는 쉘 스크립트 또는 ansible을 사용하여 구성한다.

Windows 10 에서 테스트되었다.

## 처음 사용해 보기

### 사전 준비
로컬에서 vagrant box 이미지를 만들기 위해서는 다음과 같은 사전 준비가 필요하다.
* [packer 설치](https://www.packer.io/downloads.html)
* [git bash 설치](https://git-scm.com/download/win)
  > 참고. git bash에서 실행 동작이 확인 되었다.
* [hyper-v 활성화](https://docs.microsoft.com/ko-kr/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)

### 실행 방법
다음은 우분투 xenial 64 버전 이미지를 만드는 예제이다. 
1. `packer` 실행을 위한 소스가 위치한 src 디렉토리로 이동한다.
   ```
   $ cd src
   ```
1. `packer build` 명령을 실행한다.
   ```
   $ packer build packer.hyperv.json
   ```
1. 이미지가 생성되면 명령을 실행한 디렉토리에 box 이미지가 생성되어 있는 것을 확인할 수 있다.

### 로컬 테스트
다음은 위에서 만든 box 이미지를 사용하는 방법이다.
1. 생성된 box 이미지를 로컬 box repository 에 `add` 한다.
   ```
   $ vagrant box add seonchg/ubuntu-xenial64 packer_hyperv-iso_hyperv.box --force
   ```
   * `--force` 옵션은 같은 이름의 box 이미지가 이미 등록된 경우 새로운 이미지를 덮어쓰기 위해 사용한다.
1. box 이미지를 실행한다.
   ```
   $ vagrant init seonchg/ubuntu-xenial64
   $ vagrant up
   ```

### 리모트 vagrant 업로드 
로컬에서 테스트한 이미지는 [Vagrant Cloud](https://app.vagrantup.com/)에 공개할 수 있다.

공개는 Vagrant Cloud 웹 콘솔을 통해 진행할 수 있다.

1. Vagrant Cloud에 로그인
1. `New Vagrant Box` 버튼을 클릭해 새로운 박스를 생한다.

업로드 과정은 콘솔상에서 비교적 쉽게 진행할 수 있으므로 자세한 진행 과정 설명은 생략한다.

## 새로운 이미지 생성

새로운 이미지를 만들기 위해서는 packer 설정 파일과 shell, ansible 스크립트 작성이 필요하다.

### packer 설정 파일 작성 

packer 설정 파일은 다음과 같은 포맷으로 작성된다.
```
{
    "variables": {
        ... 중간 생략 ...
    },
    "builders": [
        ... 중간 생략 ...
    ],
    "provisioners": [
        {
            "type": "shell",
            "scripts": [
                "scripts/base.sh",
                "scripts/python.sh"
            ],
            "override": {
              "hyperv-iso": {
                "execute_command": "echo 'vagrant' | sudo -S bash -c '{{.Path}}'"
              }
            }
        }
    ],
    "post-processors": [
        "vagrant"
    ]
}
```

* variables: 설정 파일에 사용되는 변수를 정의한다.
* builders: 이미지를 만들기 위해 구동해야하는 VM 설정을 지정한다. 
* provisioners: 이미지가 생성된 이후에 원하는 작업을 진행한다. ssh 설정, 애플리케이션 설치, 패키지 업데이트, ....
* post-processors: 최종 이미지가 만들어진 후의 작업을 정의한다.

box-packer는 hyperv box 이미지는 만들어 내는 것이 목적이기 때문에 다른 부분의 수정은 필요하지 않고 provisioners 설정이 필요하다.

box-packer 프로젝트에서는 shell 과 ansible provisioner를 혼용해 사용하는 것을 고려하고 있다.

#### shell script 
다음은 vagrant 계정으로 로그인해서 root 계정으로 bash.sh, python.sh을 실행하는 예제이다. 
필요한 스크립트가 있다면 별로의 스크립트 파일을 생성해 `scripts` 목록에 해당 스크립트 파일의 경로를 추가하면 된다.
```
{
    "type": "shell",
    "scripts": [
        "scripts/base.sh",
        "scripts/python.sh"
    ],
    "override": {
      "hyperv-iso": {
        "execute_command": "echo 'vagrant' | sudo -S bash -c '{{.Path}}'"
      }
    }
}
```
#### ansible scripts
다음은 ansible provisioner 설정 예이다.
ansible 스크립트 작성 방법은 여기에서 설명하지 않는다.
ansible은 vagrant 계정으로 VM에 ssh로 접근하고, 스크립트를 실행한다.
```
{
    "type": "ansible",
    "playbook_file": "./playbooks/playbook.jenkins.yml"
}
```

## 참고 자료
* [Hyper-V Builder (from an ISO)](https://www.packer.io/docs/builders/hyperv-iso.html)
  * packer 설정 메뉴얼이다.
* [Ansible Local Provisioner](https://www.packer.io/docs/provisioners/ansible-local.html)
  * ansible 프로비져너 로컬 실행을 하기 위한 설정 매뉴얼이다.
* [Shell Provisioner](https://www.packer.io/docs/provisioners/shell.html)
  * shell 프로비져너 설정 매뉴얼이다.
* [Vagrant BASE Box 만들기(CentOS 7)](https://blog.asamaru.net/2015/10/14/creating-a-vagrant-base-box/)
  * box 이미지 사이즈를 줄이는 방법등을 소개한다. 효과가 있는지는 확인이 필요하다.