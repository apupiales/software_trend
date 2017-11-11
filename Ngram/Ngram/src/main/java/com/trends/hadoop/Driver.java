package com.trends.hadoop;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hdfs.tools.GetConf;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.db.DBConfiguration;
import org.apache.hadoop.mapreduce.lib.db.DBOutputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import java.io.IOException;

/**
 * Created with IntelliJ IDEA.
 * Date: 2017-10-18
 */
public class Driver {
    public static void main(String[] args) throws IOException, InterruptedException, ClassNotFoundException{
        if (args.length < 3) {
            System.err.println("Usage: Driver <in1> <out1> <noGram>");
            System.exit(2);
        }

        String inputPath1 = args[0];
        String outputPath1 = args[1];
        int noGram = Integer.parseInt(args[2]);

        Configuration conf1 = new Configuration();
        conf1.setInt("noGram", noGram);

        // set delimiter for Input-split
        conf1.set("textinputformat.record.delimiter", "\t");


        Job job1 = Job.getInstance(conf1, "SplitNgram");
        job1.setJarByClass(SplitNgram.class);

        job1.setMapperClass(SplitNgram.SplitMapper.class);
        job1.setReducerClass(SplitNgram.SplitReducer.class);

        // set combiner
        job1.setCombinerClass(SplitNgram.SplitReducer.class);

        // mapper and reducer share the same key&value type
        job1.setOutputKeyClass(Text.class);
        job1.setOutputValueClass(IntWritable.class);

        job1.setInputFormatClass(TextInputFormat.class);
        job1.setOutputFormatClass(TextOutputFormat.class);

        TextInputFormat.setInputPaths(job1, new Path(inputPath1));
        TextOutputFormat.setOutputPath(job1, new Path(outputPath1));

        job1.waitForCompletion(true);
    }
}

