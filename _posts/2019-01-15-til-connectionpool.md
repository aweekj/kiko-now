---
layout: post
title: 커넥션 풀 - HikariCP
tags:
  - TIL/Java
---
### 지금까지의 DB접속 절차

1. DB접속 // 커넥션 연결할 때 비용이 많이 발생한다… 오버헤드가 많이 발생한다.
2. SQL 준비
3. 바인딩
4. SQL 실행
5. 한건 읽기 // ResultSet의 next()메소드로 반복해서 SQL 실행해서 한건 읽음. 
6. DB접속 close.

-> SQL 하나 실행할대마다 매번 접속했다가 끊었다가 하는 불필요한 과정이 존재함.

## Datasource 인터페이스

`<<interface>>`  
`Datasource 인터페이스`

구현하고 있는 구현체의 Connection Pool 이 DBMS와 연결을 맺는다.  
언제 속도가 느리냐면 인스턴스가 만들어질 때 자원이 소비됨.  
커넥션 연결할 때.. Datasource 인터페이스한테 커넥션을 달라고 함.  
커넥션 개체가 미리 ‘사용안함’ 이라는 자료구조에 있다가 ‘사용함’으로 이동함.  
사용함으로 이동하면 커넥션 달라고 했던애한테 결과를 리턴해줌.  

다 사용하고 나서 커넥션을 클로즈해주어야 하는데 어제 드라이버매니저로부터  
커넥션은 클로즈하면 연결이 끊어지는데  
데이터소스로부터 오는 커넥션은 클로즈하면 ‘반납’하게됨.  
반납하면 사용중이라는 자료구조에 있던게 내부적으로 다시 사용안함으로 이동함.  

이미 연결되어있는걸 사용하고 되돌려주는 방식.  
만들어줄때만 연결이 되고 그 이후로는 연결하는 시간이 소비되지 않음.  
SQL 실행만 하면 됨.  

데이터소스에 굉장히 많은 쓰레드가 한번에 많은 커넥션을 요청하면  
여러개 연결돼있던 커넥션풀이 다 사용중으로 이동하게 되고 대기하게 됨.  
DBMS가 사용할 수 있는 적절한 커넥션 수를 유지해주는게 중요함.  
커넥션을 빌려와서 SQL 실행하고 빨리 반납을 할 수 없는 상황..  
예를 들면 SQL이 느리면 점점 커넥션풀이 고갈돼서 타임아웃도 나고 장애가 발생함.  
그래서 SQL은 되도록 빠르게 동작해야 함.  

몇사람이 실수로 잘못만든 느린 SQL때문에 전체 시스템이 죽을 수도 있다.  

JPL 쓰면 SQL 공부할 필요가 없단 소리는 bullshit임.   
데이터베이스 프로그래밍을 하려면 SQL을 반드시 공부하고   
SQL 관련된 책은 한권쯤 봐둬야 함.  
특히 SELECT문을 잘 쓸 줄 알아야 함.  

DataSource는 자바가 제공하는 인터페이스이지만  
커넥션 풀은 자바가 제공하지 않음.

어제 java.sql 클래스의 드라이버도 자바에서 제공하지 않듯이.  

유명한 커넥션 풀로는 `DBCP`, `Hikaricp` 등이 있음.  

커넥션을 연결하고 실행하는 사이에 blocking이 있으면 안됨.  
예를 들면 입력을 받는동안 커넥션이 사용함에 있다가 다 입력받고 클로즈시키게 되면  
입력하다 말고 다들 점심먹으러 가면 장애가 발생함.  
입력 먼저 전부 다 받고 실행할때 받는게 좋음.  

DBCP hikaricp 둘중 하나를 사용하는데 이중에서 하나 골라서 커넥션을 얻고  
null이 아니면 is ok 출력하기.  
다른사람이 많은 객체들을 어떻게 생성할까?  
어떻게 생성해서 getconecction을 얻고 is ok 출력할 수 있을까 고민해보기  

### HikariCP를 싱글턴으로 이용하기

[GitHub - brettwooldridge/HikariCP: 光](https://github.com/brettwooldridge/HikariCP)

[Introduction to HikariCP | Baeldung](https://www.baeldung.com/hikaricp)


커넥션풀은 보통 메모리에 하나만 있어야 한다.  
(여러 객체에서 각자 다 커넥션풀 만들면 곤란하니까..)

메모리에 하나만 있는 객체를 우리는 ‘싱글턴’ 객체라고 한다.
```
public class 클래스명 {
	//2) private static 하게 자기 자신 인스턴스를 참조하는 변수를 선언
	private static 클래스명 instance = new 클래스명();

	//3) 2)에서 선언한 객체를 리턴하는 static메소드를 제공
	public static 클래스명 getInstance(){
		return instance;
	}

	//1) private 생성자를 만든다.
	private 클래스명() {
		//초기화 코드
	}
}
```
사용방법

클래스명 obj = 클래스명.getInstance(); 하면  인스턴스가 튀어나옴(new 사용안해도 됨)

-> 싱글턴을 적용하여 DBUtil 클래스를 작성한다.

```
package my.examples.jdbcboard.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBUtil {
    private static HikariConfig config = null;
    private static DataSource ds = null;
    private static DBUtil instance = new DBUtil();

    private DBUtil(){
        HikariConfig config = new HikariConfig();
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setJdbcUrl("jdbc:mysql://localhost:3306/connectdb?useUnicode=true&characterEncoding=UTF-8");
        config.setUsername("connect");
        config.setPassword("connect");

        ds = new HikariDataSource(config);
    }

    public static DBUtil getInstance(){
        return instance;
    }

    public Connection getConnection(){
        Connection conn = null;
        try {
            conn = ds.getConnection();
        }catch(Exception ex){
           ex.printStackTrace(); // 로그를 남기는 코드가 있어야 한다.
           throw new RuntimeException("DB연결을 할 수 없습니다.");
        }
        return conn;
    }

    public void close(ResultSet rs, PreparedStatement ps, Connection conn){
        try{ rs.close(); } catch(Exception ignore){}
        close(ps, conn);
    }

    public void close(PreparedStatement ps, Connection conn){
        try{ ps.close(); } catch(Exception ignore){}
        try{ conn.close(); } catch(Exception ignore){}
    }
}
```

수정된 DBUtil을 이용해 DAO도 수정한다.
```
package my.examples.jdbcboard.dao;

import my.examples.jdbcboard.dto.Board;
import my.examples.jdbcboard.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class BoardDaoImpl implements BoardDao{
    @Override
    public Board getBoard(Long idParam) {
        Board board = null; // return할 타입을 선언한다.

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // a. DB 연결 - Connection
            //    DB연결을 하려면 필요한 정보가 있다. Driver classname, DB URL, DB UserId , DB User Password
            conn = DBUtil.getInstance().getConnection();

            // b. SELECT SQL 준비 - Connection
            String sql = "select id,title,content,name,regdate,read_count from board where id = ?";
            ps = conn.prepareStatement(sql);
            // c. 바인딩 - PreparedStatement
            ps.setLong(1, idParam); // 첫번째 물음표에 5를 바인딩한다.

            // d. SQL 실행 - PreparedStatement
            rs = ps.executeQuery(); // SELECT 문장을 실행, executeUpdate() - insert, update, delete

            // e. 1건의 row를 읽어온다. row는 여러개의 컬럼으로 구성되어 있다. - ResultSet
            // f. e에서 읽어오지 못하는 경우도 있다.
            if(rs.next()){
                long id = rs.getLong(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String name = rs.getString(4);
                Date regdate = rs.getDate(5);
                int readCount = rs.getInt(6);

                board = new Board(id, title, content, name, regdate, readCount);
            }

        }catch(Exception ex){
            ex.printStackTrace();
        }finally {
            // g. ResultSet, PreparedStatement, Connection 순으로 close를 한다.
            DBUtil.close(rs, ps, conn);
        }

        return board;
    }

    @Override
    public List<Board> getBoards(int start, int limit) {
        List<Board> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            // a. DB 연결 - Connection
            //    DB연결을 하려면 필요한 정보가 있다. Driver classname, DB URL, DB UserId , DB User Password
            conn = DBUtil.getInstance().getConnection();
            if(conn != null) {
                System.out.println("conn ok!");
                System.out.println(conn.getClass().getName());
            }
            // b. SELECT SQL 준비 - Connection
            String sql = "SELECT id, title, content, name, regdate, read_count FROM board ORDER BY id DESC LIMIT ?, ?";
            ps = conn.prepareStatement(sql);
            // c. 바인딩 - PreparedStatement
            ps.setLong(1, start); // 첫번째 물음표에 5를 바인딩한다.
            ps.setInt(2, limit);

            // d. SQL 실행 - PreparedStatement
            rs = ps.executeQuery(); // SELECT 문장을 실행, executeUpdate() - insert, update, delete

            // e. 1건의 row를 읽어온다. row는 여러개의 컬럼으로 구성되어 있다. - ResultSet
            // f. e에서 읽어오지 못하는 경우도 있다.
            while(rs.next()){
                long id = rs.getLong(1);
                String title = rs.getString(2);
                String content = rs.getString(3);
                String name = rs.getString(4);
                Date regdate = rs.getDate(5);
                int readCount = rs.getInt(6);

                Board board = new Board(id, title, content, name,regdate, readCount);
                list.add(board);
            }

        }catch(Exception ex){
            ex.printStackTrace();
        }finally {
            // g. ResultSet, PreparedStatement, Connection 순으로 close를 한다.
            DBUtil.close(rs, ps, conn);
        }
        return list;
    }
}
```


## SQL 연습
SQL은 oracle에서 제공하는 scott 과 hrdb로 연습하자.

[Cocomo Coding :: SQL 실습 50문제](http://cocomo.tistory.com/117)

요런식으로.. hrdb로 JOIN같은거 연습해보자!

예) 사원 a가 어떤 나라의 어떤 지역의 어떤 부서에서 근무하는지 알아내보자.

`내 연습용 scottdb랑 hrdb`
```
hrdb@localhost
id : hr / pw : hr

scottdb@localhost
id : scott / pw : tiger
```
---
### 숙제
* 커넥션 풀 알아보기.  
* 게시판 글 쓰기 / 글 삭제 / 수정 / 페이지네이션 넣어보기..

힌트 : 답글 기능은 기존글 id가 ‘히든태그’로 넘겨져야함.

내일은 ‘트랜젝션’ 과 ‘서비스’ 에 대해 공부할 예정.
