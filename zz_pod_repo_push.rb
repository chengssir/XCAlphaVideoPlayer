#
#! /usr/bin/ruby
require 'pathname'
require 'fileutils'
require 'find'


#自定义版本最大数，
#例如最大版本是10 1.1.11要变成=> 1.2.1
#例如最大版本是20 1.20.1要变成=> 2.0.1
$MaxVersion = 100

#当前路径
File_Path = Pathname.new(__FILE__).realpath

#当前目录
Cur_path = File.dirname(File_Path)

#正常来说当前文件所在目录名称就是项目的名称
Project_Name = File.basename(Cur_path)

Podspec_Name = "#{Project_Name}.podspec"

$Project_Tag = ''

def editTag

    specFile = File.new(Podspec_Name,"r+")
 
    if specFile
        content = ""
        tag = ''
        specFile.each_line do |line|
            tmpLine = line
            tmpLine = tmpLine.gsub(' ','')
            if tmpLine.include?("s.version=")

                tmpLine = tmpLine.gsub('"','')
                tmpLine = tmpLine.gsub('\'','')
                tmpLine = tmpLine.gsub('s.version=','')

                list = tmpLine.split('.')
                one = list[0].to_i
                two = list[1].to_i
                three = list[2].to_i + 1

                #计算版本
                if three >= $MaxVersion
                    three = three % $MaxVersion;
                    two = two + 1
                    if two >= $MaxVersion
                        two = two % $MaxVersion;
                        one = one + 1
                    end
                end
                #版本号
                tag  = "#{one}.#{two}.#{three}"
                # 重新生成字符串
                line = "  s.version          = '#{tag}'\n"
                puts "\n   \033[41m 版本号#{tag} \033[0m\n\n"

            end
            content+=line
        end
        File.open(Podspec_Name,"w"){|l| #以写的方式打开文件，将buffer覆盖写入文件
            l.write(content)
        }
        return tag
    else
        printLog "\n   \033[41m >>ERROR:没找到spec文件！！ \033[0m\n\n"
    end

end



def pushCode(text = "")
    if text.length > 0
        system "git tag -d #{$Project_Tag}"
        system "git add ."
        system "git commit -m '#{text}=>更新版本号#{$Project_Tag}'"
        system "git push -u origin master"  
        system "git tag #{$Project_Tag}"
        system "git push --tags"
        puts "\n   \033[41m 提交Framework Tag版本#{$Project_Tag} \033[0m\n\n"
    else
        $Project_Tag = editTag
        system "git add ."
        system "git commit -m '提交一下数据'"
        system "git push -u origin master"  

        system "git tag #{$Project_Tag}"
        system "git push --tags"
        puts "\n   \033[41m 打Tag:版本#{$Project_Tag} \033[0m\n\n"
    end
end


def buildframework

    if File::exist?(Cur_path + '/zz_23_4_4_pod_ci.rb')
        puts "\n   \033[41m 开始编译buildframework \033[0m\n\n"
        system "ruby zz_23_4_4_pod_ci.rb"
        validationFramework

    else
        pushRepo
    end

end


def validationFramework

    newFrmFolder = "#{Cur_path}/#{Project_Name}-#{$Project_Tag}"
    #新包地址
    newFrmPath =  "#{newFrmFolder}/#{Project_Name}.xcframework"

    if File.exist?(newFrmPath)
        #清理临时文件Framework
        FileUtils.rm_r(newFrmFolder)
        printLog "\n   \033[41m 验证::打包成功 \033[0m\n"
        
        pushCode "提交Framework"

        pushRepo
    else
        printLog "\n  \033[41m 验证::打包Framework失败 \033[0m\n"
        exit
    end
end



def pushRepo

    puts "\n   \033[41m 开始本地校验 \033[0m\n\n"

    output = system "pod lib lint --allow-warnings --verbose --no-clean --skip-import-validation  --sources=https://github.com/CocoaPods/Specs.git"
    
    if output == true
        printLog " 本地校验成功 "
        system "pod trunk push #{$podspecName} --allow-warnings --skip-import-validation --verbose"
    else
        printLog " 本地校验失败"
        exit
    end

end


def printLog(text)
     for i in 0..5
        puts "\n   \033[41m #{text} \033[0m"
    end
end


 
pushCode
buildframework
 
