require 'java'
import java.util.zip.ZipFile
import java.util.zip.ZipEntry
import java.util.zip.ZipOutputStream

import java.io.FileInputStream
import java.io.FileOutputStream

class JavaZipUtil

	def self.zip(zip_path,src_dir=nil,extensions)
		fos = FileOutputStream.new(zip_path)
		zos = ZipOutputStream.new(fos)
		buffer = Java::byte[4*1024].new
		extensions.each do |extension|
			Dir["#{src_dir}/*.#{extension}"].each do |file|
				ze = ZipEntry.new(File.basename(file))
				zos.putNextEntry(ze)
				fis = FileInputStream.new(file)
				size = 0
				while ((size = fis.read(buffer)) > 0) do
					zos.write(buffer,0,size)
				end
				fis.close
				zos.closeEntry
			end	
		end
		zos.close
	end	

	def self.extract(zip_path)
		zipfile = ZipFile.new(zip_path)
		entries = zipfile.entries
		entries.each do |entry|
			is = zipfile.getInputStream(entry)
			fos = FileOutputStream.new(entry.getName)
			size = 0
			buffer = Java::byte[4*1024].new
			while ((size = is.read(buffer)) != -1) do
				fos.write(buffer,0,size)
			end
			fos.flush
			fos.close
			is.close
		end
	end	

	def self.selective_extract(zip_path,to_be_extracted)
		zipfile = ZipFile.new(zip_path)
		entries = zipfile.entries
		entries.each do |entry|
			if to_be_extracted.include? (entry.getName)
				is = zipfile.getInputStream(entry)
				fos = FileOutputStream.new(entry.getName)
				size = 0
				buffer = Java::byte[4*1024].new
				while ((size = is.read(buffer)) != -1) do
					fos.write(buffer,0,size)
				end
				fos.flush
				fos.close
				is.close
			end	
		end
	end	

end

