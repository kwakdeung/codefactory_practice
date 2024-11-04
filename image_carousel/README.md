# image_carousel

A new Flutter project.

## 위젯 생명주기

StatelessWidget

- StatelessWidget 빌드 -> 생성자 실행 -> build() 함수 실행 -> build 함수에 반환한 위젯이 화면에 렌더링
- build() 함수 재실행 X

StatefulWidget

- StatefulWidget -> constructor -> createState() -> initState() -> didChangeDependencies() -> dirty -> build() -> clean(didUpdateWidget(), setState()) -> deactivate() -> dispose()

1. StatefulWidget의 constructor 실행
2. createState() 함수 실행
3. StatefulWidget의 State 생성
4. State가 생성되면 initState()가 실행 - 단 한번만 실행
5. didChangeDependencies() 실행 - BuildContext가 제공되고 State가 의존하는 값이 변경되면 재실행됨
6. State 상태가 dirty로 설정됨
7. build() 함수가 실행되고 UI가 반영됨
8. build() 실행이 완료되면 상태가 clean으로 변경
9. 위젯이 위젯 트리에서 사라지면 deactivate()가 실행 - 일시적 또는 영구적으로 삭제될 때 실행됨
10. dispose() 실행 - 위젯이 영구적으로 삭제될 때 실행
