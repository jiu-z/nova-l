terraform {
  backend "gcs" {
    bucket = "era-k-391100-tf-state" # 替换为你的 GCS 存储桶名称
    prefix = "tf/state"              # 你可以定义一个路径前缀，以区分不同的状态文件
  }
}
