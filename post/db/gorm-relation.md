---
title: Gorm Relation
date: 2019-07-20
private:
---
# Belongs To
belongs to 会与另一个模型建立一对一关系，因此声明的每一个模型实例都会”属于”另一个模型实例。


    type User struct {
      gorm.Model
      Name string
    }

    // `Profile` belongs to `User`, `UserID` is the foreign key
    type Profile struct {
      gorm.Model
      UserID int
      User   User
      Name   string
    }

## Foreign Key
若要定义属于关系的外键必须存在, 默认外键使用所有者的类型名称及其主键。

对于上述例子，定义一个属于 User 的模型，外键应该是 UserRefer->UserID。

    type User struct {
        gorm.Model
        Name string
    }

    type Profile struct {
        gorm.Model
        Name      string
        User      User `gorm:"foreignkey:UserRefer"` // use UserRefer as foreign key
        UserRefer uint
    }

## Association ForeignKey
对于一个 belongs to 关系，GORM 通常使用所有者的主键作为外键的值，对于上面例子，外键的值是 User 的 ID。

当你关联一个 profile 到一个 user 时，GORM 将保存 user 的 ID 到 profile 的 UserID 字段。

你可以用 association_foreignkey 标签来更改它，例如：

    type User struct {
        gorm.Model
    Refer string
        Name string
    }

    type Profile struct {
        gorm.Model
        Name      string
        User      User `gorm:"association_foreignkey:Refer"` // use Refer as association foreign key
        UserRefer string
    }

## Working with Belongs To
你可以使用 Related 查找 belongs to 关系。

    db.Model(&user).Related(&profile)
    //// SELECT * FROM profiles WHERE user_id = 111; // 111 is user's ID

# Many to many

