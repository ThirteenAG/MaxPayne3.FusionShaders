float4 param5 : register(c201);
float4 param6 : register(c202);
float4 param7 : register(c203);
sampler2D sampFiltered : register(s1);

float4 main(float2 texcoord : TEXCOORD) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	r0.xy = texcoord.xy * 2 + -1;
	r0.xy = r0.xy + -param6.xy;
	r0.xy = r0.xy + 1E-05;
	r1.xz = float2(1E-05, 8);
	r0.z = r1.x + param6.z;
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r1.y = r0.z * r0.w + 1E-05;
	r0.xyz = r0.www * r0.xyz;
	r0.w = log2(r1.y);
	r0.w = (r0.z >= 0) ? r0.w : -16.60964;
	r1.y = param7.x * r1.z + r1.x;
	r0.w = r0.w * r1.y;
	r0.w = exp2(r0.w);
	r1.yzw = r0.www * float3(0, 1, 1);
	r2.xyz = float3(1, 1, 0) * texcoord.xyx;
	r2.w = param5.x;
	r2 = tex2Dlod(sampFiltered, r2);
	r2 = r2.xxyy * 2 + -1;
	r0.w = dot(r2.yw, -r2.yw) + 1;
	r2 = r2 * param6.w;
	r2 = r2 * float4(1, 0, 0, 1);
	r2.xyz = r2.zwz + r2.xyy;
	r2.w = max(r0.w, 0);
	r0.w = rsqrt(r2.w);
	r0.w = 1 / r0.w;
	r2.xyz = r0.www * float3(0, 0, 1) + r2.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r0.x = dot(r3.xyz, r0.xyz);
	r0.y = r0.x + 1E-05;
	r0.y = log2(r0.y);
	r0.x = (r0.x >= 0) ? r0.y : -16.60964;
	r0.y = r1.x + param7.x;
	r0.x = r0.x * r0.y;
	r0.x = exp2(r0.x);
	r0.xyz = r0.xxx * param7.yyy + -r1.yzw;
	o.xyz = max(r0.xyz, 0);
	o.w = 1;

	return o;
}
