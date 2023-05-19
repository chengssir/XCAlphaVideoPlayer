#!/usr/bin/env ruby
require 'pathname'
require 'fileutils'
require 'find'

##------------------------------------------修改spec文件-----------------------------------------------------------##
class TNFT
    #当前路径
    path = Pathname.new(__FILE__).realpath
    #当前目录
    PROJECT_DIR = File.dirname(path)

    #正常来说当前文件所在目录名称就是项目的名称
    PROJECT_NAME = File.basename(PROJECT_DIR)

    #podspec路径
    specPath = "#{PROJECT_DIR}/#{PROJECT_NAME}.podspec"

    #记录版本号
    PROJECT_VERSION = ''



    ###------------------------------------------获取版本号----------------------------------------------------------##
    # 获取版本号
    def getVersion
        puts "\n========================开始获取版本号========================"
        specFile = File.new("#{PROJECT_NAME}.podspec","r+")
        if specFile
            lineIdx=0
            content = ""
            specFile.each_line do |line|
                tmpLine = line
                tmpLine = tmpLine.gsub(' ','')
                if tmpLine.include?("s.version=")

                    tmpLine = tmpLine.gsub('"','')
                    tmpLine = tmpLine.gsub('\'','')
                    tmpLine = tmpLine.gsub('s.version=','')

                    PROJECT_VERSION.replace tmpLine.strip
                end
                content+=line
            end
            File.open("#{PROJECT_NAME}.podspec","w"){|l| #以写的方式打开文件，将buffer覆盖写入文件
              l.write(content)
            }
        else
          puts ">>ERROR:没找到spec文件！！"
        end
    end




    ###------------------------------------------清理pod缓存----------------------------------------------------------##
    def cleanProjectCache
        exampleDir = "#{PROJECT_DIR}/Example"
        podsDir = "#{exampleDir}/Pods"

        puts "开始清理依赖库文件 ，#{podsDir}"
        FileUtils.rm_r("#{exampleDir}/#{PROJECT_NAME}.xcworkspace")
        FileUtils.rm("#{exampleDir}/Podfile.lock")
        FileUtils.rm_r "#{podsDir}"
        puts "清理完毕"
    end


    # 没有什么意义的，主要是pod cache clean --all 清除缓存
    def cleanPodCache
        exampleDir = "#{PROJECT_DIR}/Example"
        podsDir = "#{exampleDir}/Pods"
        isDir = File.directory?(podsDir)
        if isDir

            puts "\n========================清理pod缓存========================"

            Dir.foreach(podsDir) do |filename|
                    if filename != "." &&
                        filename != ".." &&
                        filename != "Local Podspecs" &&
                        filename != "Target Support Files" &&
                        File.directory?("#{podsDir}/#{filename}") &&
                        filename != "Pods.xcodeproj" &&
                        filename != "Headers"

                        syswinRepoItem = "#{File.expand_path('~')}/.cocoapods/repos/MMSpecs/#{filename}"
                        if File.directory?(syswinRepoItem)
                            puts "clean \033[31m #{filename} \033[0m 仓库\n"
                            
                            system "pod cache clean #{filename} --all"
                        else
                            puts "跳过 \033[31m #{filename} \033[0m\n"
                        end
                    end
            end

        else
            puts "\npods目录不存在，#{podsDir}"
        end
    end



    ##------------------------------------------打包Framework----------------------------------------------------------##
    def buildFramework

        puts "\n========================开始打包Framework========================"
        frmPath = "#{PROJECT_DIR}/Frameworks"
        FileUtils.mkdir_p(frmPath) unless File.exist?(frmPath)

        system "#{PROJECT_NAME}_use_code=1 pod framework #{PROJECT_NAME}.podspec --no-force  --spec-sources=https://github.com/CocoaPods/Specs.git"        
        # system "pod framework #{PROJECT_NAME}.podspec --no-force  --spec-sources=https://github.com/CocoaPods/Specs.git"        
        
        newFrmFolder = "#{PROJECT_DIR}/#{PROJECT_NAME}-#{PROJECT_VERSION}"
        puts "\n新包地址 -----> " + newFrmFolder
        newFrmPath =  "#{newFrmFolder}/#{PROJECT_NAME}.xcframework"
        puts "\n新包绝对路径 -----> " + newFrmPath
        if File.exist?(newFrmPath)
            puts "\n迁移文件"
            originFrmPath = "#{frmPath}/#{PROJECT_NAME}.xcframework"
            puts "originFrmPath地址 #{originFrmPath}"

            if File.exist?(originFrmPath)
                FileUtils.rm_r(originFrmPath)
                puts '\n删除原有Framework ' + originFrmPath
            end
            puts "\n拷贝Framework到目标路径Frameworks" + newFrmPath
            FileUtils.cp_r(newFrmPath, originFrmPath)
        else
            puts "\n buildFramework脚本打包Framework失败"
        end
    end

    def installFramework
        puts "\n========================重新安装Framework========================"
        FileUtils.cd("Example")
        system "pod install"
    end




end

TNFT.new.getVersion

puts "    项目名称 > \033[31m #{TNFT::PROJECT_NAME} \033[0m\n"
puts "    项目版本 > \033[31m #{TNFT::PROJECT_VERSION} \033[0m\n"
puts "    项目路径 > \033[31m #{TNFT::PROJECT_DIR} \033[0m\n"

TNFT.new.cleanPodCache
TNFT.new.buildFramework

frmPath = "#{TNFT::PROJECT_DIR}/Frameworks/#{TNFT::PROJECT_NAME}.xcframework"
puts "新包绝对路径： -----> " + frmPath

 if File.exist?(frmPath)
    TNFT.new.cleanProjectCache
    TNFT.new.installFramework
    puts "\033[41m >>> 请编译项目成功后提交代码，打tag，推送pod库 <<< \033[0m\n"
 else
    puts "\033[41m >>> Framework脚本出错，重新执行脚本 <<< \033[0m\n"
 end




