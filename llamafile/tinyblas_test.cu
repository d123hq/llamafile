// -*- mode:c++;indent-tabs-mode:nil;c-basic-offset:4;coding:utf-8 -*-
// vi: set et ft=c++ ts=4 sts=4 sw=4 fenc=utf-8 :vi
//
// Copyright 2024 Mozilla Foundation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "gemm.h"
#include "tester.h"

void checkTinyblasWorksHHHS() {
    double TOLERANCE = 1;

    float alpha = 1;
    float beta = 0;
    int m = 4096;
    int n = 1024;
    int k = 577;
    int lda = k;
    int ldb = k;
    int ldc = m;
    cuda_memory<half> A{lda * m};
    cuda_memory<half> B{ldb * n};
    cuda_memory<half> C{ldc * n};
    cuda_memory<half> G{ldc * n};
    randomize(k, m, A.p, lda);
    randomize(k, n, B.p, ldb);
    cublas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    broadcast(m, n, C.p, ldc, TOMBSTONE);
    broadcast(m, n, G.p, ldc, TOMBSTONE);
    gemmref(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    tinyblas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
    CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);

    test_matmul([&](int m, int n, int k, int l, float alpha, float beta) {
        int lda = m + l;
        int ldb = k + l;
        int ldc = m + l;
        cuda_memory<half> A{lda * k};
        cuda_memory<half> B{ldb * n};
        cuda_memory<half> C{ldc * n};
        cuda_memory<half> G{ldc * n};
        randomize(m, k, A.p, lda);
        randomize(k, n, B.p, ldb);
        broadcast(m, n, G.p, ldc, TOMBSTONE);
        broadcast(m, n, C.p, ldc, TOMBSTONE);
        gemmref(false, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
        tinyblas(false, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
        CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);
    });
}

void checkTinyblasWorksHHSS() {
    double TOLERANCE = 1;

    float alpha = 1;
    float beta = 0;
    int m = 4096;
    int n = 1024;
    int k = 1536;
    int lda = k;
    int ldb = k;
    int ldc = m;
    cuda_memory<half> A{lda * m};
    cuda_memory<half> B{ldb * n};
    cuda_memory<float> C{ldc * n};
    cuda_memory<float> G{ldc * n};
    randomize(k, m, A.p, lda);
    randomize(k, n, B.p, ldb);
    cublas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    broadcast(m, n, G.p, ldc, TOMBSTONE);
    broadcast(m, n, C.p, ldc, TOMBSTONE);
    gemmref(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    tinyblas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
    CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);

    test_matmul([&](int m, int n, int k, int l, float alpha, float beta) {
        int lda = k + l;
        int ldb = k + l;
        int ldc = m + l;
        cuda_memory<half> A{lda * m};
        cuda_memory<half> B{ldb * n};
        cuda_memory<float> C{ldc * n};
        cuda_memory<float> G{ldc * n};
        randomize(k, m, A.p, lda);
        randomize(k, n, B.p, ldb);
        broadcast(m, n, G.p, ldc, TOMBSTONE);
        broadcast(m, n, C.p, ldc, TOMBSTONE);
        gemmref(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
        tinyblas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
        CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);
    });
}

void checkTinyblasWorksSSSS() {
    double TOLERANCE = 1;

    float alpha = 1;
    float beta = 0;
    int m = 4096;
    int n = 1024;
    int k = 1020;
    int lda = k;
    int ldb = k;
    int ldc = m;
    cuda_memory<float> A{lda * m};
    cuda_memory<float> B{ldb * n};
    cuda_memory<float> C{ldc * n};
    cuda_memory<float> G{ldc * n};
    randomize(k, m, A.p, lda);
    randomize(k, n, B.p, ldb);
    cublas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    broadcast(m, n, C.p, ldc, TOMBSTONE);
    broadcast(m, n, G.p, ldc, TOMBSTONE);
    gemmref(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    tinyblas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
    CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);

    test_matmul([&](int m, int n, int k, int l, float alpha, float beta) {
        int lda = m + l;
        int ldb = k + l;
        int ldc = m + l;
        cuda_memory<float> A{lda * k};
        cuda_memory<float> B{ldb * n};
        cuda_memory<float> C{ldc * n};
        cuda_memory<float> G{ldc * n};
        randomize(m, k, A.p, lda);
        randomize(k, n, B.p, ldb);
        broadcast(m, n, G.p, ldc, TOMBSTONE);
        broadcast(m, n, C.p, ldc, TOMBSTONE);
        gemmref(false, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
        tinyblas(false, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
        CHECK(TOLERANCE, m, n, k, G.p, ldc, C.p, ldc);
    });
}

void try_size(int m, int n, int k) {
    printf("\n");
    float alpha = 1;
    float beta = 0;
    int lda = k;
    int ldb = k;
    int ldc = m;
    cuda_memory<half> A{lda * m};
    cuda_memory<half> B{ldb * n};
    cuda_memory<half> C{ldc * n};
    cuda_memory<half> G{ldc * n};
    randomize(k, m, A.p, lda);
    randomize(k, n, B.p, ldb);
    cublas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    broadcast(m, n, C.p, ldc, TOMBSTONE);
    broadcast(m, n, G.p, ldc, TOMBSTONE);
    gemmref(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, G.p, ldc);
    tinyblas(true, false, m, n, k, alpha, A.p, lda, B.p, ldb, beta, C.p, ldc);
    CHECK(1, m, n, k, G.p, ldc, C.p, ldc);
}

int main(int argc, char *argv[]) {
    try_size(512, 512, 512);
    try_size(5760, 1, 128); // mistral 7b
    try_size(128, 1, 5696); // mistral 7b
    try_size(14336, 512, 4096); // mistral 7b
    try_size(128, 128, 128);
    try_size(256, 256, 256);
    try_size(512, 512, 512);
    try_size(1024, 1024, 1024);
    try_size(2048, 2048, 2048);
    try_size(32000, 512, 4096);
    RUN(checkTinyblasWorksSSSS());
    RUN(checkTinyblasWorksHHSS());
    RUN(checkTinyblasWorksHHHS());
}
