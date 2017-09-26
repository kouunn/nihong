# 1.先安装 ImageMagick: http://www.imagemagick.org/script/binary-releases.php#windows
# 2.创建 initializers 文件：config/initializers/paperclip.rb 存入下面的代码
# 3.重启 webserver
# 设置 command_path ，请将 c:/program files/imagemagick-6.5.5-Q16 改为你的 ImageMagick 的安装目录
Paperclip.options[:command_path] = "D:/Tools/ImageMagick-6.8.6-Q16"
Paperclip.options[:swallow_stderr] = false

def run cmd, params = "", expected_outcodes = 0
  command = %Q<#{%Q[#{path_for_command(cmd)} #{params}].gsub(/\s+/, " ")}>
  command = "#{command} 2>#{bit_bucket}" if Paperclip.options[:swallow_stderr]
  output = `#{command}`
  unless [expected_outcodes].flatten.include?($?.exitstatus)
    raise PaperclipCommandLineError, "Error while running #{cmd}"
  end
  output
end